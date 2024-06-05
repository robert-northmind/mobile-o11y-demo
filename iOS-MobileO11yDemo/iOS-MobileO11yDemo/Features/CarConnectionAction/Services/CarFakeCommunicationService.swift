//
//  CarFakeCommunicationService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

protocol CarFakeCommunicationServiceProtocol {
    var connectedCarPublisher: Published<Car?>.Publisher { get }

    func connectToCar() async
    func disconnectFromCar() async
    
    func lockDoors() async throws
    func unlockDoors() async throws
}

class CarFakeCommunicationService: CarFakeCommunicationServiceProtocol {
    @Published var connectedCar: Car?
    var connectedCarPublisher: Published<Car?>.Publisher { $connectedCar }
    
    func connectToCar() async {
        await makeFakeConnectionDelay(scale: .longSeconds)
        connectedCar = Car()
    }
    
    func disconnectFromCar() async {
        await makeFakeConnectionDelay(scale: .longSeconds)
        connectedCar = nil
    }

    func lockDoors() async throws {
        await makeFakeConnectionDelay(scale: .shortSeconds)
        
        try throwFakeError10percentOfTimes()

        var updatedCar = connectedCar
        updatedCar?.carDoorStatus = CarDoorStatus(status: "locked")
        connectedCar = updatedCar
    }
    
    func unlockDoors() async throws {
        await makeFakeConnectionDelay(scale: .shortSeconds)
        
        try throwFakeError10percentOfTimes()

        var updatedCar = connectedCar
        updatedCar?.carDoorStatus = CarDoorStatus(status: "unlocked")
        connectedCar = updatedCar
    }

    private func makeFakeConnectionDelay(scale: FakeDelayScale) async {
        try? await Task.sleep(nanoseconds: scale.getDelayInNanoseconds())
    }
    
    private func throwFakeError10percentOfTimes() throws {
        if Int.random(in: 1...10) == 1 {
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
            return UInt64.random(in: 5_000_000...1_000_000_000)
        case .longSeconds:
            return UInt64.random(in: 5_000_000...1_500_000_000)
        }
    }
}

struct CarCommunicationCommand {
    let percentCompleted: Int
    
    init(percentCompleted: Int = 0) {
        self.percentCompleted = min(max(percentCompleted, 0), 100)
    }
}

private struct CarFakeCommunicationServiceKey: InjectionKey {
    static var currentValue: CarFakeCommunicationServiceProtocol = CarFakeCommunicationService()
}

extension InjectedValues {
    var carFakeCommunicationService: CarFakeCommunicationServiceProtocol {
        get { Self[CarFakeCommunicationServiceKey.self] }
        set { Self[CarFakeCommunicationServiceKey.self] = newValue }
    }
}
