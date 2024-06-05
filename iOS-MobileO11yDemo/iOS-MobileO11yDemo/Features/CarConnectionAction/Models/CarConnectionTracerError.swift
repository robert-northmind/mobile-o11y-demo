//
//  CarConnectionTracerError.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 05.06.24.
//

import Foundation

enum CarConnectionTracerError: Error, CustomStringConvertible {
    case invalidState

    var description: String {
            switch self {
            case .invalidState:
                return "Invalid state"
            }
        }
}

