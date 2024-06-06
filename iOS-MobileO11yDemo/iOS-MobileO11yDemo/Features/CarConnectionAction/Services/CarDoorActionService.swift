//
//  CarDoorActionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

protocol CarDoorActionServiceProtocol {
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var isLockedPublisher: Published<Bool?>.Publisher { get }

    func lockDoors() async throws
    func unlockDoors() async throws
}

class CarDoorActionService: CarDoorActionServiceProtocol {
    @Published var isLoading: Bool = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    @Published var isLocked: Bool?
    var isLockedPublisher: Published<Bool?>.Publisher { $isLocked }
    
    private let carCommunication: CarCommunicationProtocol
    private var cancellables = Set<AnyCancellable>()
    private let tracer: CarConnectionTracerProtocol

    init(
        carCommunication: CarCommunicationProtocol = InjectedValues[\.carCommunication],
        tracer: CarConnectionTracerProtocol = InjectedValues[\.carConnectionTracer]
    ) {
        self.carCommunication = carCommunication
        self.tracer = tracer

        carCommunication
            .connectedCarPublisher
            .sink { [weak self] connectedCar in
                guard let self = self else { return }
                self.isLocked = connectedCar?.carDoorStatus.isLocked
            }
            .store(in: &cancellables)
    }

    func lockDoors() async throws {
        isLoading = true
        let span = tracer.startLockDoorsSpan()

        defer { isLoading = false }
        do {
            _ = try await carCommunication.lockDoors()
            tracer.endLockDoorSpan(status: .ok)
        } catch {
            let errorMessage = "LockDoors failed with error: \(error)"
            logger.log(errorMessage, severity: .error)
            span.addEvent(name: errorMessage)
            tracer.endLockDoorSpan(status: .error(description: errorMessage))
            throw error
        }
    }

    func unlockDoors() async throws {
        isLoading = true
        let span = tracer.startUnlockDoorsSpan()
        
        defer { isLoading = false }
        do {
            _ = try await carCommunication.unlockDoors()
            tracer.endUnlockDoorSpan(status: .ok)
        } catch {
            let errorMessage = "UnlockDoors failed with error: \(error)"
            logger.log(errorMessage, severity: .error)
            span.addEvent(name: errorMessage)
            tracer.endUnlockDoorSpan(status: .error(description: errorMessage))
            throw error
        }
    }
}

private struct CarDoorActionServiceKey: InjectionKey {
    static var currentValue: CarDoorActionServiceProtocol = CarDoorActionService()
}

extension InjectedValues {
    var carDoorActionService: CarDoorActionServiceProtocol {
        get { Self[CarDoorActionServiceKey.self] }
        set { Self[CarDoorActionServiceKey.self] = newValue }
    }
}
