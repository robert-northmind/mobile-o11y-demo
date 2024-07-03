//
//  CarConnectionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine
import OpenTelemetryApi

protocol CarConnectionServiceProtocol {
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var isConnectedPublisher: Published<Bool>.Publisher { get }
    var connectedCarPublisher: Published<Car?>.Publisher { get }

    func connectToCar() async
    func disconnectFromCar() async
}

class CarConnectionService: CarConnectionServiceProtocol {
    @Published var isLoading: Bool = false
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }

    @Published var isConnected: Bool = false
    var isConnectedPublisher: Published<Bool>.Publisher { $isConnected }
    
    var connectedCarPublisher: Published<Car?>.Publisher
    
    private let carCommunication: CarCommunicationProtocol
    private var cancellables = Set<AnyCancellable>()
    private let tracer: CarConnectionTracerProtocol
    
    init(
        carCommunication: CarCommunicationProtocol = InjectedValues[\.carCommunication],
        tracer: CarConnectionTracerProtocol = InjectedValues[\.carConnectionTracer]
    ) {
        self.carCommunication = carCommunication
        self.tracer = tracer
        self.connectedCarPublisher = carCommunication.connectedCarPublisher

        carCommunication
            .connectedCarPublisher
            .sink { [weak self] connectedCar in
                guard let self = self else { return }
                if let connectedCar = connectedCar {
                    self.isConnected = true
                    self.tracer.updateCarAttributes(car: connectedCar)
                } else {
                    self.isConnected = false
                }
            }
            .store(in: &cancellables)
    }

    func connectToCar() async {
        isLoading = true
        await carCommunication.connectToCar()
        tracer.connectedToCar()
        isLoading = false
    }
    
    func disconnectFromCar() async {
        isLoading = true
        await carCommunication.disconnectFromCar()
        tracer.disconnectedFromCar()
        isLoading = false
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
