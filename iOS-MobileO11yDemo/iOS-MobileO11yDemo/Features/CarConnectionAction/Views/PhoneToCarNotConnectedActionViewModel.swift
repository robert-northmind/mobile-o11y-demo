//
//  PhoneToCarNotConnectedActionViewModel.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

class PhoneToCarNotConnectedActionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
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
    }
    
    func connectToCar() {
        Task {
            _ = await carConnectionService.connectToCar()
        }
    }
}
