//
//  CarSoftwareUpdateService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 05.06.24.
//

import Foundation
import Combine
import OpenTelemetryApi

protocol CarSoftwareUpdateServiceProtocol {
    var currentVersionPublisher: Published<CarSoftwareVersion?>.Publisher { get }
    var nextVersionPublisher: Published<CarSoftwareVersion?>.Publisher { get }
    var updateProgressPublisher: Published<Double>.Publisher { get }
    
    func updateSoftware() async throws
}

class CarSoftwareUpdateService: CarSoftwareUpdateServiceProtocol {
    @Published var currentVersion: CarSoftwareVersion?
    var currentVersionPublisher: Published<CarSoftwareVersion?>.Publisher { $currentVersion }
    
    @Published var nextVersion: CarSoftwareVersion?
    var nextVersionPublisher: Published<CarSoftwareVersion?>.Publisher { $nextVersion }
    
    var updateProgressPublisher: Published<Double>.Publisher
    
    private let fakeCommunicationService: CarFakeCommunicationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    private let tracer: CarConnectionTracerProtocol
    private var updateSoftwareSpan: Span?
    
    init(
        fakeCommunicationService: CarFakeCommunicationServiceProtocol = InjectedValues[\.carFakeCommunicationService],
        tracer: CarConnectionTracerProtocol = InjectedValues[\.carConnectionTracer]
    ) {
        self.fakeCommunicationService = fakeCommunicationService
        self.tracer = tracer
        self.updateProgressPublisher = fakeCommunicationService.updateProgressPublisher
        
        fakeCommunicationService
            .connectedCarPublisher
            .sink { [weak self] connectedCar in
                guard let self = self else { return }
                let currentVersion = connectedCar?.info.softwareVersion
                self.currentVersion = currentVersion
                
                if let currentVersion = currentVersion {
                    if self.nextVersion == nil {
                        self.nextVersion = CarSoftwareVersionFactory().getRandomNextVersion(currentVersion: currentVersion)
                    }
                } else {
                    self.nextVersion = nil
                }
            }
            .store(in: &cancellables)

        fakeCommunicationService.updateProgressPublisher
            .sink { [weak self] updateProgress in
                self?.updateSoftwareSpan?.addEvent(name: "Progress: \(updateProgress)%")
            }
            .store(in: &cancellables)
    }

    func updateSoftware() async throws {
        guard let nextVersion = nextVersion else { return }
        
        let span = tracer.startUpdateSoftwareSpan()
        updateSoftwareSpan = span
        
        do {
            if let currentVersion = currentVersion {
                span.addEvent(name: "Starting update! Current version is: \(currentVersion), will update to: \(nextVersion)")
            }

            try await fakeCommunicationService.updateSoftware(nextVersion)
            if let currentVersion = currentVersion {
                self.nextVersion = CarSoftwareVersionFactory().getRandomNextVersion(currentVersion: currentVersion)
                span.addEvent(name: "Updated! New version is: \(nextVersion)")
            }
            tracer.endUpdateSoftwareSpan(status: .ok)
        } catch {
            let errorMessage = "Failed to update software with error: \(error)"
            logger.log(errorMessage, severity: .error)
            span.addEvent(name: errorMessage)
            tracer.endUpdateSoftwareSpan(status: .error(description: errorMessage))
            throw error
        }
    }
}

private struct CarSoftwareUpdateServiceKey: InjectionKey {
    static var currentValue: CarSoftwareUpdateServiceProtocol = CarSoftwareUpdateService()
}

extension InjectedValues {
    var carSoftwareUpdateService: CarSoftwareUpdateServiceProtocol {
        get { Self[CarSoftwareUpdateServiceKey.self] }
        set { Self[CarSoftwareUpdateServiceKey.self] = newValue }
    }
}

