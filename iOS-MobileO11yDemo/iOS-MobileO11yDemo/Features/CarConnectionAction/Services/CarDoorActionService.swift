//
//  CarDoorActionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

protocol CarDoorActionServiceProtocol {
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var isLockedPublisher: Published<Bool>.Publisher { get }

    func lockDoors() async
    func unlockDoors() async
}

class CarDoorActionService: CarDoorActionServiceProtocol {
    @Published var isLoading: Bool = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    
    @Published var isLocked: Bool = true
    var isLockedPublisher: Published<Bool>.Publisher { $isLocked }
    
    private let carConnectionService: CarConnectionServiceProtocol
    private let fakeCommunicationService: CarFakeCommunicationService
    
    private var car: Car?

    init(
        carConnectionService: CarConnectionServiceProtocol = InjectedValues[\.carConnectionService]
    ) {
        self.carConnectionService = carConnectionService
        self.fakeCommunicationService = CarFakeCommunicationService()
    }

    func getDoorStatus() async -> CarDoorStatus? {
        return car?.carDoorStatus
    }
    
    func lockDoors() async {
//        do {
//            _ = try await fakeCommunicationService.makeFakeCommunication(
//                command: CarCommunicationCommand()
//            )
//            car.carDoorStatus = CarDoorStatus(status: "locked")
//        } catch {
//            
//        }
    }

    func unlockDoors() async {
//        do {
//            _ = try await fakeCommunicationService.makeFakeCommunication(
//                command: CarCommunicationCommand()
//            )
//            car.carDoorStatus = CarDoorStatus(status: "unlocked")
//        } catch {
//            
//        }
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
