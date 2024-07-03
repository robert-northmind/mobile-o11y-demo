//
//  PhoneToCarLockUnlockActionViewModel.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation
import Combine

@MainActor
class PhoneToCarLockUnlockActionViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var isLocked: Bool?
    
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
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
            do {
                try await doorActionService.unlockDoors()
            } catch {
                alertMessage = "\(error)"
                showAlert = true
            }
        }
    }
    
    func lockAction() {
        Task {
            do {
                try await doorActionService.lockDoors()
            } catch {
                alertMessage = "\(error)"
                showAlert = true
            }
        }
    }
}
