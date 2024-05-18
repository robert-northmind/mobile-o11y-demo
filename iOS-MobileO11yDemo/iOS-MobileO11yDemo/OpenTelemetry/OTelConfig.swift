//
//  OTelConfig.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation

struct OTelConfig {
    // Put your token here
    let token = ""

    // Put your instanceId here
    let instanceId = ""

    // Put your endpoint url
    // Like this: https://otlp-gateway-prod-eu-west-2.grafana.net/otlp
    let endpointUrl = "https://otlp-gateway-prod-eu-west-2.grafana.net/otlp"

    let serviceName = "mobile-O11y-ios-demo-app"
    let deploymentEnvironment = "production"

    let instrumentationScopeName = "main-instrumentation"
    let instrumentationScopeVersion = "semver:1.0.0"
}

