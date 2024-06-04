//
//  CarFakeCommunicationService.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

class CarFakeCommunicationService {
    func makeFakeConnectionDelay() async {
        let randomDelay = UInt64.random(in: 1_000_000...5_000_000)
        try? await Task.sleep(nanoseconds: randomDelay)
    }

    func makeFakeCommunication(
        command: CarCommunicationCommand
    ) async throws -> CarCommunicationCommand {
        if shouldCreateFakeError() {
            throw CarCommunicationError.allCases.randomElement() ?? .mysticMagicError
        }

        await makeFakeConnectionDelay()
        
        return CarCommunicationCommand(percentCompleted: command.percentCompleted+10)
    }

    private func shouldCreateFakeError() -> Bool {
        return Int.random(in: 1...10) == 1 // 10% chance
    }
}

struct CarCommunicationCommand {
    let percentCompleted: Int
    
    init(percentCompleted: Int = 0) {
        self.percentCompleted = min(max(percentCompleted, 0), 100)
    }
}
