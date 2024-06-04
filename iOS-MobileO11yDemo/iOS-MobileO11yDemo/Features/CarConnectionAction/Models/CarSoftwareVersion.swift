//
//  CarSoftwareVersion.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

struct CarSoftwareVersion {
    let major: Int
    let minor: Int
    let patch: Int
}

class CarSoftwareVersionFactory {
    func getRandomVersion() -> CarSoftwareVersion {
        return CarSoftwareVersion(
            major: Int.random(in: 1...5),
            minor: Int.random(in: 0...20),
            patch: Int.random(in: 0...4)
        )
    }
}
