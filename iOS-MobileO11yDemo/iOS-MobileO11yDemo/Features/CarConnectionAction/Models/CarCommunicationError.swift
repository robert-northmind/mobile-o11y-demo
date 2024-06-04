//
//  CarCommunicationError.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 04.06.24.
//

import Foundation

enum CarCommunicationError: Error, CaseIterable {
    case timeout, randomEcuError, mysticMagicError
}
