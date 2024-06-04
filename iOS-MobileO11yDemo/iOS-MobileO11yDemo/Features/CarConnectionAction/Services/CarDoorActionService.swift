//
//  CarDoorActionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

class CarDoorActionService {
    private let carConnection: CarConnection
    private let fakeCommunicationService: CarFakeCommunicationService

    init(carConnection: CarConnection) {
        self.carConnection = carConnection
        self.fakeCommunicationService = CarFakeCommunicationService()
    }

    func getDoorStatus() async -> CarDoorStatus {
        return carConnection.carDoorStatus
    }
    
    func lockDoors() async {
        do {
            _ = try await fakeCommunicationService.makeFakeCommunication(
                command: CarCommunicationCommand()
            )
            carConnection.carDoorStatus = CarDoorStatus(status: "locked")
        } catch {
            
        }
    }

    func unlockDoors() async {
        do {
            _ = try await fakeCommunicationService.makeFakeCommunication(
                command: CarCommunicationCommand()
            )
            carConnection.carDoorStatus = CarDoorStatus(status: "unlocked")
        } catch {
            
        }
    }
}
