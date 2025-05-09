//
//  iOS_MobileO11yDemoApp.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import SwiftUI
import FaroOtelExporter
import OpenTelemetryApi

@main
struct iOS_MobileO11yDemoApp: App {
    init() {
        OTelTraces.instance.initialize()
        OTelLogs.instance.initialize()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    logger.log("IosMobileO11yDemo was started", severity: .debug)
                    logger.log(FaroOtelConstants.ChangeUser.otelBody, severity: .info, attributes: [
                        FaroOtelConstants.ChangeUser.AttributeKeys.username: "some_user",
                        FaroOtelConstants.ChangeUser.AttributeKeys.userEmail: "some_user@example.com",
                        FaroOtelConstants.ChangeUser.AttributeKeys.userId: "12345"
                    ]) 
                    logger.log("user has logged in", severity: .info)
                }
        }
    }
}
