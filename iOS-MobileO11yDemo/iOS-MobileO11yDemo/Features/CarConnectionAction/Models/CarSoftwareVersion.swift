//
//  CarSoftwareVersion.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

struct CarSoftwareVersion: CustomStringConvertible {
    let major: Int
    let minor: Int
    let patch: Int
    
    var description: String {
        return "(v\(major).\(minor).\(patch))"
    }
}

class CarSoftwareVersionFactory {
    func getRandomVersion() -> CarSoftwareVersion {
        return CarSoftwareVersion(
            major: Int.random(in: 1...5),
            minor: Int.random(in: 0...20),
            patch: Int.random(in: 0...4)
        )
    }
    
    func getRandomNextVersion(currentVersion: CarSoftwareVersion) -> CarSoftwareVersion {
        return CarSoftwareVersion(
            major: Int.random(in: currentVersion.major...(currentVersion.major+1)),
            minor: Int.random(in: currentVersion.minor...(currentVersion.minor+1)),
            patch: Int.random(in: (currentVersion.patch+1)...(currentVersion.patch+5))
        )
    }
}
