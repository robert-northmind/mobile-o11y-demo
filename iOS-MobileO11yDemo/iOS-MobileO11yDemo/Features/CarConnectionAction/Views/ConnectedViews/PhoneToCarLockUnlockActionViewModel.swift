//
//  PhoneToCarLockUnlockActionViewModel.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

class PhoneToCarLockUnlockActionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLocked: Bool = true
    
    private let doorActionService: CarDoorActionServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        doorActionService: CarDoorActionServiceProtocol = InjectedValues[\.carDoorActionService]
    ) {
        self.doorActionService = doorActionService
        
        doorActionService
            .isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        doorActionService
            .isLockedPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLocked, on: self)
            .store(in: &cancellables)
    }
    
    func unlockAction() {
        Task {
            await doorActionService.unlockDoors()
        }
    }
    
    func lockAction() {
        Task {
            await doorActionService.lockDoors()
        }
    }
}
