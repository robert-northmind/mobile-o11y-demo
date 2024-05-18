//
//  Logger.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 18.05.24.
//

import Foundation
import OpenTelemetryApi
import OSLog

let logger = Logger()

class Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    private let otelLogger = OTelLogs.instance.getLogger()
    private let osLogger = os.Logger(subsystem: subsystem, category: "main")
    private let dateFormatter = DateFormatter()

    fileprivate init() {
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
    }
    
    func log(
        _ message: String,
        severity: Severity,
        timestamp: Date = Date(),
        attributes: [String: String] = [:]
    ) {
        let currentDate = Date()
        let formattedDate = dateFormatter.string(from: currentDate)
        osLogger.log("\(formattedDate): [\(severity)]: \(message)")
        
        var updateAttributes = attributes
        updateAttributes["level"] = "\(severity)"
        otelLogger.log(message, severity: severity, timestamp: timestamp, attributes: updateAttributes)
    }
}
