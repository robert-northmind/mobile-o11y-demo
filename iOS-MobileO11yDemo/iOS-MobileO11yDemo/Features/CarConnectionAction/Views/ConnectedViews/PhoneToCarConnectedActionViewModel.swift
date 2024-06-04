//
//  PhoneToCarConnectedActionViewModel.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

class PhoneToCarConnectedActionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var vehicleInfo: String = ""
    
    private let carConnectionService: CarConnectionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        carConnectionService: CarConnectionServiceProtocol = InjectedValues[\.carConnectionService]
    ) {
        self.carConnectionService = carConnectionService
        
        carConnectionService
            .isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)
        
        carConnectionService
            .connectedCarPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] car in
                guard let self = self else { return }
                if let car = car {
                    self.vehicleInfo = "\(car.info.model.rawValue)\nVIN: \(car.info.vin)"
                } else {
                    self.vehicleInfo = ""
                }
            }
            .store(in: &cancellables)
    }
    
    func disconnectFromCar() {
        Task {
            await carConnectionService.disconnectFromCar()
        }
    }
}
