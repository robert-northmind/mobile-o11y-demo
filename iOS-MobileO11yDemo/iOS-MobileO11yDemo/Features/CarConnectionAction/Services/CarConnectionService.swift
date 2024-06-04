//
//  CarConnectionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

protocol CarConnectionServiceProtocol {
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var isConnectedPublisher: Published<Bool>.Publisher { get }
    var connectedCarPublisher: Published<Car?>.Publisher { get }

    func connectToCar() async -> Car
    func disconnectFromCar() async
}

class CarConnectionService: CarConnectionServiceProtocol {
    @Published var isLoading: Bool = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }

    @Published var isConnected: Bool = false
    var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }
    
    @Published var connectedCar: Car?
    var connectedCarPublisher: Published<Car?>.Publisher { $connectedCar }
    
    func connectToCar() async -> Car {
        await updateCarConnection(shouldConnect: true)
        let car = Car()
        connectedCar = car
        return car
    }
    
    func disconnectFromCar() async {
        await updateCarConnection(shouldConnect: false)
        connectedCar = nil
    }

    private func updateCarConnection(shouldConnect: Bool) async {
        isLoading = true
        await addFakeConnectionDelay()
        isConnected = shouldConnect
        isLoading = false
    }
    
    private func addFakeConnectionDelay() async {
        let randomDelay = UInt64.random(in: 1_000_000_000...2_000_000_000)
        try? await Task.sleep(nanoseconds: randomDelay)
    }
}

private struct CarConnectionServiceKey: InjectionKey {
    static var currentValue: CarConnectionServiceProtocol = CarConnectionService()
}

extension InjectedValues {
    var carConnectionService: CarConnectionServiceProtocol {
        get { Self[CarConnectionServiceKey.self] }
        set { Self[CarConnectionServiceKey.self] = newValue }
    }
}
