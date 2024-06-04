//
//  CarConnectionService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

@MainActor
class CarConnectionService: ObservableObject {
    private init() {}
    
    static let instance = CarConnectionService()
    
    @Published var isLoading: Bool = false

    @Published var isConnected: Bool = false
    
    func connectToCar() async -> CarConnection {
        await updateCarConnection(shouldConnect: true)
        return CarConnection()
    }
    
    func disconnectFromCar() async {
        await updateCarConnection(shouldConnect: false)
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
