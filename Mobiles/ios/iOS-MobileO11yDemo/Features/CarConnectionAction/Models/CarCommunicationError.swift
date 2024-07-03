//
//  CarCommunicationError.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

enum CarCommunicationError: Error, CaseIterable, CustomStringConvertible {
    case timeout, randomEcuError, mysticMagicError

    var description: String {
            switch self {
            case .timeout:
                return "Communication Timeout"
            case .randomEcuError:
                return "Random ECU Error"
            case .mysticMagicError:
                return "Mystic Magic Error"
            }
        }
}
