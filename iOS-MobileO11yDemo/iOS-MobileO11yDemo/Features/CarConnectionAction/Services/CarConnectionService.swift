//
//  CarConnectionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

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
    
    private let fakeCommunicationService: CarFakeCommunicationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fakeCommunicationService: CarFakeCommunicationServiceProtocol = InjectedValues[\.carFakeCommunicationService]
    ) {
        self.fakeCommunicationService = fakeCommunicationService
        self.connectedCarPublisher = fakeCommunicationService.connectedCarPublisher

        fakeCommunicationService
            .connectedCarPublisher
            .sink { [weak self] connectedCar in
                guard let self = self else { return }
                self.isConnected = connectedCar != nil
            }
            .store(in: &cancellables)
    }

    func connectToCar() async {
        isLoading = true
        await fakeCommunicationService.connectToCar()
        isLoading = false
    }
    
    func disconnectFromCar() async {
        isLoading = true
        await fakeCommunicationService.disconnectFromCar()
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
