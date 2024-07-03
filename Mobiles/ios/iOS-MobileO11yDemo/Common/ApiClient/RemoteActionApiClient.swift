//
//  RemoteActionApiClient.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation
import Combine
import OpenTelemetryApi

protocol RemoteActionApiClientProtocol {
    func getDoorStatus() async throws -> CarDoorStatus
    func setDoorStatus(action: ChangeDoorStatusRemoteAction) async throws
}

class RemoteActionApiClient: RemoteActionApiClientProtocol {
    private let basePath = "http://localhost:3000"

    func getDoorStatus() async throws -> CarDoorStatus {
        logger.log("Fetching doorStatus", severity: .debug)

        guard let url = URL(string: "\(basePath)/door-status") else {
            throw ApiError.invalidUrl
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let dataStr = String(data: data, encoding: .utf8)
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                logger.log("Failed to get door status: \(String(describing: dataStr))", severity: .error)
                throw ApiError.statusNotOk
            }
            guard let result = try? JSONDecoder().decode(CarDoorStatus.self, from: data) else {
                logger.log("Failed to parse door status: \(String(describing: dataStr))", severity: .error)
                throw ApiError.decodingError
            }
            logger.log("Got door status: \(result)", severity: .debug)
            return result
        } catch {
            logger.log("Failed to fetch door status with error: \(error)", severity: .error)
            throw ApiError.requestError
        }
    }
    
    func setDoorStatus(action: ChangeDoorStatusRemoteAction) async throws {
        logger.log("Sending setDoorStatus to be status: \(action.status)", severity: .debug)
        
        guard let url = URL(string: "\(basePath)/set-door-status") else {
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONEncoder().encode(action)
            request.httpBody = jsonData
            let (data, response) = try await URLSession.shared.data(for: request)
            let dataStr = String(data: data, encoding: .utf8)

            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                logger.log("Failed to set door status: \(String(describing: dataStr))", severity: .error)
                throw ApiError.statusNotOk
            }

            logger.log("Successfully set new door status: \(String(describing: dataStr))", severity: .debug)
        } catch {
            logger.log("Failed to set door status with error: \(error)", severity: .error)
            throw error
        }
    }
}

private struct RemoteActionApiClientKey: InjectionKey {
    static var currentValue: RemoteActionApiClientProtocol = RemoteActionApiClient()
}

extension InjectedValues {
    var remoteActionApiClient: RemoteActionApiClientProtocol {
        get { Self[RemoteActionApiClientKey.self] }
        set { Self[RemoteActionApiClientKey.self] = newValue }
    }
}
