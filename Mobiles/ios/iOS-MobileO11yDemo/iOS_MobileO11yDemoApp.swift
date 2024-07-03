//
//  iOS_MobileO11yDemoApp.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import SwiftUI

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
                }
        }
    }
}
