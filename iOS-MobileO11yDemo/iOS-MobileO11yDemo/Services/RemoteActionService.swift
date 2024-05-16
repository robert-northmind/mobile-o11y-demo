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
    func lockDoors() async
    func unlockDoors() async
    func getDoorStatus() async -> CarDoorStatus?
}

class RemoteActionService: RemoteActionServiceProtocol {
    private let logger: Logger
    private let tracer: Tracer
    private let apiClient: RemoteActionApiClientProtocol
    
    init(
        apiClient: RemoteActionApiClientProtocol = InjectedValues[\.remoteActionApiClient],
        logger: Logger = OTelLogs.instance.getLogger(),
        tracer: Tracer = OTelTraces.instance.getTracer()
    ) {
        self.apiClient = apiClient
        self.logger = logger
        self.tracer = tracer
    }
    
    func getDoorStatus() async -> CarDoorStatus? {
        let getStatusSpan = tracer.spanBuilder(spanName: "GetDoorStatus")
            .setSpanKind(spanKind: .server)
            .setActive(true)
            .startSpan()
        defer {
            getStatusSpan.end()
        }
        
        do {
            let doorStatus = try await apiClient.getDoorStatus()
            getStatusSpan.setAttribute(key: "CurrentDoorStatus", value: doorStatus.status.safeTracingName)
            getStatusSpan.status = .ok
            return doorStatus
        } catch {
            getStatusSpan.status = .error(description: error.localizedDescription)
            return nil
        }
    }
    
    func lockDoors() async {
        await changeDoorStatus(action: LockDoorStatusRemoteAction())
    }
    
    func unlockDoors() async {
        await changeDoorStatus(action: UnlockDoorStatusRemoteAction())
    }
    
    private func changeDoorStatus(action: ChangeDoorStatusRemoteAction) async {
        logger.log("Sending request to OMC (observable-motor-command) to set door status to: \(action.status)", severity: .debug)
        
        let setStatusSpan = tracer.spanBuilder(spanName: "SetDoorStatus")
            .setSpanKind(spanKind: .server)
            .setActive(true)
            .startSpan()
        setStatusSpan.setAttribute(key: "ExpectedStatus", value: action.status.safeTracingName)
        
        do {
            try await apiClient.setDoorStatus(action: action)
        } catch {
            logger.log("DoorStatus failed to update with error: \(error)", severity: .error)
            setStatusSpan.status = .error(description: error.localizedDescription)
            setStatusSpan.end()
            print("## Set Status initial failed!")
            return
        }

        print("## String to poll for status changes")
        let didUpdateStatus = await pollForDoorStatus(toBe: action.status, parentSpan: setStatusSpan)
        if didUpdateStatus {
            logger.log("DoorStatus did update! It is now: \(action.status)", severity: .debug)
            setStatusSpan.status = .ok
            print("## Set Status completed correctly!")
        } else {
            logger.log("DoorStatus did not update!", severity: .error)
            setStatusSpan.status = .error(description: "Status did not update")
            print("## Set Status failed!")
        }
        setStatusSpan.end()
    }
    
    private func pollForDoorStatus(toBe status: String, parentSpan: Span, startTime: Date = Date()) async -> Bool {
        guard !startTime.isOlderThan(seconds: 30) else {
            logger.log("Door status polling timed out. Status never changed to \(status)", severity: .error)
            return false
        }
   
        let checkStatusSpan = tracer.spanBuilder(spanName: "CheckDoorStatusPoller")
            .setParent(parentSpan)
            .setSpanKind(spanKind: .server)
            .startSpan()
        defer {
            checkStatusSpan.end()
        }
        
        do {
            let latestDoorStatus = try await apiClient.getDoorStatus()
            checkStatusSpan.setAttribute(key: "LatestDoorStatus", value: latestDoorStatus.status.safeTracingName)
            if latestDoorStatus.status == status {
                checkStatusSpan.status = .ok
                print("## Got correct status")
                return true
            } else {
                checkStatusSpan.status = .error(description: "Value not updated yet. We want: \(status), we got: \(latestDoorStatus.status)")
            }
        } catch {
            checkStatusSpan.status = .error(description: error.localizedDescription)
        }
        
        // Wait for 2 seconds
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000)

        print("## Polling again")
        return await pollForDoorStatus(toBe: status, parentSpan: parentSpan, startTime: startTime)
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
