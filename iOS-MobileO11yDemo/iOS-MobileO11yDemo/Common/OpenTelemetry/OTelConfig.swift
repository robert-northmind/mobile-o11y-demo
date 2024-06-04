//
//  OTelConfig.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation

struct OTelConfig {
    // Put your Otel header here. In this format: `Basic {base64 encoded instanceId:token}`
    let otelHeaders = ""

    // Put your endpoint url
    let endpointUrl = ""

    let serviceName = "mobile-O11y-ios-demo-app"
    let deploymentEnvironment = "production"

    let instrumentationScopeName = "main-instrumentation"
    let instrumentationScopeVersion = "semver:1.0.0"
}

