//
//  ErrorSimulationType.swift
//  iOS-MobileO11yDemo
//
//  Created for error simulation and observability testing
//

import Foundation

/// Represents the type of error simulation to apply for remote car actions.
/// This is used for testing and observability purposes.
enum ErrorSimulationType: String, CaseIterable, Identifiable {
    /// No error - normal operation
    case none
    
    /// Simulate a 400 Bad Request error
    case badRequest = "400"
    
    /// Simulate a 500 Internal Server Error
    case internalServerError = "500"
    
    /// Random error (15% probability) - default behavior
    case random
    
    var id: String { rawValue }
    
    /// Converts the enum to the header value format
    var headerValue: String {
        switch self {
        case .none:
            return "none"
        case .badRequest:
            return "400"
        case .internalServerError:
            return "500"
        case .random:
            return "random"
        }
    }
    
    /// User-friendly display name for the UI
    var displayName: String {
        switch self {
        case .none:
            return "No Error"
        case .badRequest:
            return "Bad Request (400)"
        case .internalServerError:
            return "Internal Server Error (500)"
        case .random:
            return "Random (15%)"
        }
    }
}

