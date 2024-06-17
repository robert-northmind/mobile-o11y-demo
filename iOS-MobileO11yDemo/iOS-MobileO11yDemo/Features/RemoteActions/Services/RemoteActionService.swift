//
//  RemoteActionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation
import Combine
import OpenTelemetryApi

protocol RemoteActionServiceProtocol {
    func lockDoors() async throws
    func unlockDoors() async throws
    func getDoorStatus() async -> CarDoorStatus?
}

class RemoteActionService: RemoteActionServiceProtocol {
    private let tracer: Tracer
    private let apiClient: RemoteActionApiClientProtocol
    private let selectedCarService: SelectedCarServiceProtocol
    
    init(
        apiClient: RemoteActionApiClientProtocol = InjectedValues[\.remoteActionApiClient],
        tracer: Tracer = OTelTraces.instance.getTracer(),
        selectedCarService: SelectedCarServiceProtocol = InjectedValues[\.selectedCarService]
    ) {
        self.apiClient = apiClient
        self.tracer = tracer
        self.selectedCarService = selectedCarService
    }
    
    func getDoorStatus() async -> CarDoorStatus? {
        let getStatusSpan = tracer.spanBuilder(spanName: "Remote-GetDoorStatus")
            .setSpanKind(spanKind: .server)
            .setActive(true)
            .startSpan()
        applySpanAttributes(span: getStatusSpan)
        defer {
            getStatusSpan.end()
        }
        
        do {
            let doorStatus = try await apiClient.getDoorStatus()
            getStatusSpan.setAttribute(key: "CurrentDoorStatus", value: doorStatus.status.safeTracingName)
            getStatusSpan.addEvent(name: "Successfully got status: \(doorStatus.status)")
            getStatusSpan.status = .ok
            return doorStatus
        } catch {
            getStatusSpan.addEvent(name: "Failed to get status. Error: \(error)")
            getStatusSpan.status = .error(description: "\(error)")
            return nil
        }
    }
    
    func lockDoors() async throws {
        try await changeDoorStatus(action: LockDoorStatusRemoteAction())
    }
    
    func unlockDoors() async throws {
        try await changeDoorStatus(action: UnlockDoorStatusRemoteAction())
    }
    
    private func changeDoorStatus(action: ChangeDoorStatusRemoteAction) async throws {
        logger.log("Sending request to OMC (observable-motor-command) to set door status to: \(action.status)", severity: .debug)
        
        let setStatusSpan = tracer.spanBuilder(spanName: "Remote-SetDoorStatus")
            .setSpanKind(spanKind: .server)
            .setActive(true)
            .startSpan()
        applySpanAttributes(span: setStatusSpan)
        setStatusSpan.setAttribute(key: "ExpectedStatus", value: action.status.safeTracingName)
        
        do {
            try await apiClient.setDoorStatus(action: action)
            setStatusSpan.addEvent(name: "Successfully did send set-request. Now polling..")
        } catch {
            let message = "DoorStatus failed to update with error: \(error)"
            logger.log(message, severity: .error)
            setStatusSpan.addEvent(name: message)
            setStatusSpan.status = .error(description: error.localizedDescription)
            setStatusSpan.end()
            throw error
        }

        logger.log("Start to poll for status changes", severity: .info)
        let didUpdateStatus = await pollForDoorStatus(toBe: action.status, parentSpan: setStatusSpan)
        if didUpdateStatus {
            let message = "DoorStatus did update! It is now: \(action.status)"
            logger.log(message, severity: .debug)
            setStatusSpan.addEvent(name: message)
            setStatusSpan.status = .ok
            setStatusSpan.end()
            return
        } else {
            let message = "DoorStatus did not update!"
            logger.log(message, severity: .error)
            setStatusSpan.addEvent(name: message)
            setStatusSpan.status = .error(description: message)
            setStatusSpan.end()
            throw ApiError.statusDidNotUpdate
        }
    }
    
    private func pollForDoorStatus(toBe status: String, parentSpan: Span, startTime: Date = Date()) async -> Bool {
        guard !startTime.isOlderThan(seconds: 20) else {
            logger.log("Door status polling timed out. Status never changed to \(status)", severity: .error)
            return false
        }
   
        let checkStatusSpan = tracer.spanBuilder(spanName: "Remote-CheckDoorStatusPoller")
            .setParent(parentSpan)
            .setSpanKind(spanKind: .server)
            .startSpan()
        applySpanAttributes(span: checkStatusSpan)
        
        do {
            let latestDoorStatus = try await apiClient.getDoorStatus()
            parentSpan.addEvent(name: "GotStatusUpdate", attributes: ["LatestDoorStatus": AttributeValue.string(latestDoorStatus.status.safeTracingName)])
            checkStatusSpan.setAttribute(key: "LatestDoorStatus", value: latestDoorStatus.status.safeTracingName)
            if latestDoorStatus.status == status {
                checkStatusSpan.status = .ok
                logger.log("Got correct status", severity: .info)
                return true
            }
        } catch {
            let message = "Get door status failed with error: \(error)"
            logger.log(message, severity: .error)
            checkStatusSpan.addEvent(name: message)
            checkStatusSpan.status = .error(description: message)
        }
        checkStatusSpan.end()
        
        // Wait for 3 seconds
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000)

        logger.log("Starting new poll", severity: .info)
        return await pollForDoorStatus(toBe: status, parentSpan: parentSpan, startTime: startTime)
    }
    
    private func applySpanAttributes(span: Span) {
        let car = selectedCarService.selectedCar

        span.setAttribute(
            key: "CarVin",
            value: car.info.vin.safeTracingName
        )
        span.setAttribute(
            key: "CarModel",
            value: car.info.model.rawValue.safeTracingName
        )
        span.setAttribute(
            key: "CarColor",
            value: car.info.color.rawValue.safeTracingName
        )
        span.setAttribute(
            key: "CarProductonDate",
            value: car.info.productionDate.description.safeTracingName
        )
        span.setAttribute(
            key: "CarSoftwareVersion",
            value: car.info.softwareVersion.description.safeTracingName
        )
        span.setAttribute(
            key: "ActionType",
            value: "Remote"
        )
    }
}

private struct RemoteActionServiceKey: InjectionKey {
    static var currentValue: RemoteActionServiceProtocol = RemoteActionService()
}

extension InjectedValues {
    var remoteActionService: RemoteActionServiceProtocol {
        get { Self[RemoteActionServiceKey.self] }
        set { Self[RemoteActionServiceKey.self] = newValue }
    }
}

extension String {
    var safeTracingName: String {
        return self.replacingOccurrences(of: " ", with: "_")
    }
}

extension Date {
    func isOlderThan(seconds: Int) -> Bool {
        // Get the current date and time
        let currentDate = Date()
        // Calculate the time interval between the initial date and the current date
        let timeInterval = currentDate.timeIntervalSince(self)
        // Check if the time interval is greater than 30 seconds (30.0)
        return timeInterval > Double(seconds)
    }
}
