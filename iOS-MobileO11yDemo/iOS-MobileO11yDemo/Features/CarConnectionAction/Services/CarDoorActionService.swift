//
//  CarDoorActionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

class CarDoorActionService {
    private let car: Car
    private let fakeCommunicationService: CarFakeCommunicationService

    init(car: Car) {
        self.car = car
        self.fakeCommunicationService = CarFakeCommunicationService()
    }

    func getDoorStatus() async -> CarDoorStatus {
        return car.carDoorStatus
    }
    
    func lockDoors() async {
        do {
            _ = try await fakeCommunicationService.makeFakeCommunication(
                command: CarCommunicationCommand()
            )
            car.carDoorStatus = CarDoorStatus(status: "locked")
        } catch {
            
        }
    }

    func unlockDoors() async {
        do {
            _ = try await fakeCommunicationService.makeFakeCommunication(
                command: CarCommunicationCommand()
            )
            car.carDoorStatus = CarDoorStatus(status: "unlocked")
        } catch {
            
        }
    }
}
