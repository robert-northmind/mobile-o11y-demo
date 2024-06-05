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
    
    private let fakeCommunicationService: CarFakeCommunicationServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    init(
        fakeCommunicationService: CarFakeCommunicationServiceProtocol = InjectedValues[\.carFakeCommunicationService]
    ) {
        self.fakeCommunicationService = fakeCommunicationService
        fakeCommunicationService
            .connectedCarPublisher
            .sink { [weak self] connectedCar in
                guard let self = self else { return }
                self.isLocked = connectedCar?.carDoorStatus.isLocked
            }
            .store(in: &cancellables)
    }

    func lockDoors() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            _ = try await fakeCommunicationService.lockDoors()
        } catch {
            logger.log("LockDoors failed with error: \(error)", severity: .error)
            throw error
        }
    }

    func unlockDoors() async throws {
        isLoading = true
        defer { isLoading = false }
        do {
            _ = try await fakeCommunicationService.unlockDoors()
        } catch {
            logger.log("UnlockDoors failed with error: \(error)", severity: .error)
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
