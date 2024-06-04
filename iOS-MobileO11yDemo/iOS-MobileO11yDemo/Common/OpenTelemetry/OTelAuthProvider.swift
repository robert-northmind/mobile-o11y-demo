//
//  OTelAuthProvider.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation

struct OTelAuthProvider {
    private let otelConfig = OTelConfig()

    func getAuthHeader() -> [String: String] {
        return ["Authorization": otelConfig.otelHeaders]
    }
}
