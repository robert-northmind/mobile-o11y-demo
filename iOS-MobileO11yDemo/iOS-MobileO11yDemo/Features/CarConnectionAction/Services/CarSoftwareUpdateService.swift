//
//  CarSoftwareUpdateService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 05.06.24.
//

import Foundation
import Combine

protocol CarSoftwareUpdateServiceProtocol {
    var currentVersionPublisher: Published<CarSoftwareVersion?>.Publisher { get }
    var nextVersionPublisher: Published<CarSoftwareVersion?>.Publisher { get }
    var updateProgressPublisher: Published<Double>.Publisher { get }
    
    func updateSoftware() async
}

class CarSoftwareUpdateService: CarSoftwareUpdateServiceProtocol {
    @Published var currentVersion: CarSoftwareVersion?
    var currentVersionPublisher: Published<CarSoftwareVersion?>.Publisher { $currentVersion }
    
    @Published var nextVersion: CarSoftwareVersion?
    var nextVersionPublisher: Published<CarSoftwareVersion?>.Publisher { $nextVersion }
    
    var updateProgressPublisher: Published<Double>.Publisher
    
    private let fakeCommunicationService: CarFakeCommunicationServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        fakeCommunicationService: CarFakeCommunicationServiceProtocol = InjectedValues[\.carFakeCommunicationService]
    ) {
        self.fakeCommunicationService = fakeCommunicationService
        self.updateProgressPublisher = fakeCommunicationService.updateProgressPublisher
        
        fakeCommunicationService
            .connectedCarPublisher
            .sink { [weak self] connectedCar in
                guard let self = self else { return }
                let currentVersion = connectedCar?.info.softwareVersion
                self.currentVersion = currentVersion
                
                if let currentVersion = currentVersion {
                    self.nextVersion = CarSoftwareVersionFactory().getRandomNextVersion(currentVersion: currentVersion)
                } else {
                    self.nextVersion = nil
                }
            }
            .store(in: &cancellables)
    }

    func updateSoftware() async {
        guard let nextVersion = nextVersion else { return }
        try? await fakeCommunicationService.updateSoftware(nextVersion)
    }
}

private struct CarSoftwareUpdateServiceKey: InjectionKey {
    static var currentValue: CarSoftwareUpdateServiceProtocol = CarSoftwareUpdateService()
}

extension InjectedValues {
    var carSoftwareUpdateService: CarSoftwareUpdateServiceProtocol {
        get { Self[CarSoftwareUpdateServiceKey.self] }
        set { Self[CarSoftwareUpdateServiceKey.self] = newValue }
    }
}

