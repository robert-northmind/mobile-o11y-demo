//
//  CarConnectionTracer.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 05.06.24.
//

import Foundation
import OpenTelemetryApi

protocol CarConnectionTracerProtocol {
    func connectedToCar()
    func disconnectedFromCar()
    func updateCarAttributes(car: Car)
    
    func startLockDoorsSpan() -> Span
    func endLockDoorSpan(status: Status)
    func startUnlockDoorsSpan() -> Span
    func endUnlockDoorSpan(status: Status)
    
    func startUpdateSoftwareSpan() -> Span
    func endUpdateSoftwareSpan(status: Status)
}

class CarConnectionTracer: CarConnectionTracerProtocol {
    private let tracer: Tracer
    
    private var connectedSpan: Span?
    private var lockDoorsSpan: Span?
    private var unlockDoorsSpan: Span?
    private var updateSoftwareSpan: Span?
    
    private var lastActiveCar: Car?
    private var lastFailedStatus: Status?
    
    init(
        tracer: Tracer = OTelTraces.instance.getTracer()
    ) {
        self.tracer = tracer
    }
    
    func connectedToCar() {
        lastFailedStatus = nil
        connectedSpan = tracer.spanBuilder(spanName: "Phone2Car-ConnectedToCar")
            .setSpanKind(spanKind: .server)
            .startSpan()
        applySpanAttributes()
    }

    func disconnectedFromCar() {
        if let lastFailedStatus = lastFailedStatus {
            connectedSpan?.status = lastFailedStatus
        } else {
            connectedSpan?.status = .ok
        }
        connectedSpan?.end()
        connectedSpan = nil
        lastActiveCar = nil
    }
    
    func updateCarAttributes(car: Car) {
        lastActiveCar = car
        applySpanAttributes()
    }
    
    func startLockDoorsSpan() -> Span {
        let spanBuilder = tracer.spanBuilder(spanName: "Phone2Car-LockDoors")
            .setSpanKind(spanKind: .server)
        if let connectedSpan = connectedSpan {
            spanBuilder.setParent(connectedSpan)
        }
        let span = spanBuilder.startSpan()
        lockDoorsSpan = span
        applySpanAttributes()
        return span
    }
    
    func endLockDoorSpan(status: Status) {
        if case .error(_) = status {
            lastFailedStatus = status
        }

        lockDoorsSpan?.status = status
        lockDoorsSpan?.end()
        lockDoorsSpan = nil
    }

    func startUnlockDoorsSpan() -> Span {
        let spanBuilder = tracer.spanBuilder(spanName: "Phone2Car-UnlockDoors")
            .setSpanKind(spanKind: .server)
        if let connectedSpan = connectedSpan {
            spanBuilder.setParent(connectedSpan)
        }
        let span = spanBuilder.startSpan()
        unlockDoorsSpan = span
        applySpanAttributes()
        return span
    }
    
    func endUnlockDoorSpan(status: Status) {
        if case .error(_) = status {
            lastFailedStatus = status
        }
        
        unlockDoorsSpan?.status = status
        unlockDoorsSpan?.end()
        unlockDoorsSpan = nil
    }
    
    func startUpdateSoftwareSpan() -> Span {
        let spanBuilder = tracer.spanBuilder(spanName: "Phone2Car-UpdateSoftware")
            .setSpanKind(spanKind: .server)
        if let connectedSpan = connectedSpan {
            spanBuilder.setParent(connectedSpan)
        }
        let span = spanBuilder.startSpan()
        updateSoftwareSpan = span
        applySpanAttributes()
        return span
    }
    
    func endUpdateSoftwareSpan(status: Status) {
        if case .error(_) = status {
            lastFailedStatus = status
        }
        
        updateSoftwareSpan?.status = status
        updateSoftwareSpan?.end()
        updateSoftwareSpan = nil
    }
    
    private func applySpanAttributes() {
        guard let car = lastActiveCar else { return }

        let allSpans = [
            connectedSpan,
            lockDoorsSpan,
            unlockDoorsSpan,
            updateSoftwareSpan
        ]
        let activeSpans: [Span] = allSpans.compactMap { $0 }

        activeSpans.forEach { span in
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
                value: "Phone2Car"
            )
        }
    }
}

private struct CarConnectionTracerKey: InjectionKey {
    static var currentValue: CarConnectionTracerProtocol = CarConnectionTracer()
}

extension InjectedValues {
    var carConnectionTracer: CarConnectionTracerProtocol {
        get { Self[CarConnectionTracerKey.self] }
        set { Self[CarConnectionTracerKey.self] = newValue }
    }
}
