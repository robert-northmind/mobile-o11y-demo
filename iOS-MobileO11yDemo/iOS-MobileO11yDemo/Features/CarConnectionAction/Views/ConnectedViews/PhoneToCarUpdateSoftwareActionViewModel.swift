//
//  PhoneToCarUpdateSoftwareActionViewModel.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 05.06.24.
//

import Foundation
import Combine

@MainActor
class PhoneToCarUpdateSoftwareActionViewModel: ObservableObject {
    @Published var currentSoftwareVersion: String = ""
    @Published var nextSoftwareVersion: String = ""

    @Published var progress: Double = 0
    @Published var isUpdating: Bool = false
    
    private let softwareUpdateService: CarSoftwareUpdateServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        softwareUpdateService: CarSoftwareUpdateServiceProtocol = InjectedValues[\.carSoftwareUpdateService]
    ) {
        self.softwareUpdateService = softwareUpdateService
        softwareUpdateService.currentVersionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] currentVersion in
                guard let self = self else { return }
                if let currentVersion = currentVersion {
                    self.currentSoftwareVersion = currentVersion.description
                } else {
                    self.currentSoftwareVersion = ""
                }
            }
            .store(in: &cancellables)
        
        softwareUpdateService.nextVersionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] nextVersion in
                guard let self = self else { return }
                if let nextVersion = nextVersion {
                    self.nextSoftwareVersion = nextVersion.description
                } else {
                    self.nextSoftwareVersion = ""
                }
            }
            .store(in: &cancellables)
        
        softwareUpdateService.updateProgressPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.progress, on: self)
            .store(in: &cancellables)
    }

    func updateSoftware() {
        Task {
            isUpdating = true
            await softwareUpdateService.updateSoftware()
            isUpdating = false
        }
    }
}
