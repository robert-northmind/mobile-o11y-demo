//
//  CarDoorStatus.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation

struct CarDoorStatus: Codable, Hashable {
    let status: String
    
    private enum CodingKeys: String, CodingKey {
        case status = "status"
    }
}

extension CarDoorStatus {
    var isLocked: Bool {
        return status == "locked"
    }
}
