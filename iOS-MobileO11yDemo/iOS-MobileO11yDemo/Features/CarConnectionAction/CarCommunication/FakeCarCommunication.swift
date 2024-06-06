//
//  FakeCarCommunication.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

protocol CarCommunicationProtocol {
    var connectedCarPublisher: Published<Car?>.Publisher { get }
    var updateProgressPublisher: Published<Double>.Publisher { get }

    func connectToCar() async
    func disconnectFromCar() async
    
    func lockDoors() async throws
    func unlockDoors() async throws
    
    func updateSoftware(_ nextVersion: CarSoftwareVersion) async throws
}

class FakeCarCommunication: CarCommunicationProtocol {
    @Published var connectedCar: Car?
    var connectedCarPublisher: Published<Car?>.Publisher { $connectedCar }
    
    @Published var updateProgress: Double = 0
    var updateProgressPublisher: Published<Double>.Publisher { $updateProgress }
    
    func connectToCar() async {
        await makeFakeConnectionDelay(scale: .longSeconds)
        connectedCar = CarFactory().getRandomCar()
    }
    
    func disconnectFromCar() async {
        await makeFakeConnectionDelay(scale: .longSeconds)
        connectedCar = nil
    }

    func lockDoors() async throws {
        await makeFakeConnectionDelay(scale: .shortSeconds)
        
        try throwFakeError(probabilityInPercent: 10)

        if let connectedCar = connectedCar {
            self.connectedCar = Car(
                info: connectedCar.info,
                carDoorStatus: CarDoorStatus(status: "locked")
            )
        }
    }
    
    func unlockDoors() async throws {
        await makeFakeConnectionDelay(scale: .shortSeconds)
        
        try throwFakeError(probabilityInPercent: 10)

        if let connectedCar = connectedCar {
            self.connectedCar = Car(
                info: connectedCar.info,
                carDoorStatus: CarDoorStatus(status: "unlocked")
            )
        }
    }
    
    func updateSoftware(_ nextVersion: CarSoftwareVersion) async throws {
        updateProgress = 0
        while updateProgress < 100 {
            await makeFakeConnectionDelay(scale: .longSeconds)
            try throwFakeError(probabilityInPercent: 6)
            updateProgress = min(updateProgress+10, 100)
        }

        await makeFakeConnectionDelay(scale: .longSeconds)

        if let connectedCar = connectedCar {
            let updateCarInfo = CarInfo(
                vin: connectedCar.info.vin,
                model: connectedCar.info.model,
                color: connectedCar.info.color,
                productionDate: connectedCar.info.productionDate,
                softwareVersion: nextVersion
            )
            self.connectedCar = Car(
                info: updateCarInfo,
                carDoorStatus: connectedCar.carDoorStatus
            )
        }
    }

    private func makeFakeConnectionDelay(scale: FakeDelayScale) async {
        try? await Task.sleep(nanoseconds: scale.getDelayInNanoseconds())
    }
    
    private func throwFakeError(probabilityInPercent: Int) throws {
        let safeProbability = max(min(probabilityInPercent, 100), 0)
        let randomValue = Int.random(in: 0..<100)
        if randomValue < safeProbability {
            throw CarCommunicationError.allCases.randomElement() ?? .mysticMagicError
        }
    }
}

enum FakeDelayScale {
    case shortSeconds
    case longSeconds
    
    func getDelayInNanoseconds() -> UInt64 {
        switch self {
        case .shortSeconds:
            return UInt64.random(in: 8_000_000...1_200_000_000)
        case .longSeconds:
            return UInt64.random(in: 8_000_000...1_900_000_000)
        }
    }
}

private struct CarCommunicationKey: InjectionKey {
    static var currentValue: CarCommunicationProtocol = FakeCarCommunication()
}

extension InjectedValues {
    var carCommunication: CarCommunicationProtocol {
        get { Self[CarCommunicationKey.self] }
        set { Self[CarCommunicationKey.self] = newValue }
    }
}
