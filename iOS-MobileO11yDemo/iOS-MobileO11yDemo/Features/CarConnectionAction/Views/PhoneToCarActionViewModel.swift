//
//  PhoneToCarActionViewModel.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

class PhoneToCarActionViewModel: ObservableObject {
    @Published var isConnected: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        carConnectionService: CarConnectionServiceProtocol = InjectedValues[\.carConnectionService]
    ) {
        carConnectionService
            .isConnectedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isConnected, on: self)
            .store(in: &cancellables)
    }
}
