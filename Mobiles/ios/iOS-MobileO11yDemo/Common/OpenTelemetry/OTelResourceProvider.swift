//
//  OTelResourceProvider.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import OpenTelemetryApi
import OpenTelemetrySdk
import ResourceExtension

struct OTelResourceProvider {
    static let serviceVersion: String = getRandomServiceVersion()
    
    func getResource() -> Resource {
        let otelConfig = OTelConfig()
        let defaultResources = DefaultResources().get()
        let customResource = Resource(
            attributes: [
                "service.name": AttributeValue.string(otelConfig.serviceName),
                "deployment.environment": AttributeValue.string(otelConfig.deploymentEnvironment),
                "service.version": AttributeValue.string(Self.serviceVersion),
            ]
        )
        return defaultResources.merging(other: customResource)
    }
    
    static private func getRandomServiceVersion() -> String {
        let versions = [
            "1.0.0",
            "1.0.6",
            "2.3.6"
        ]
        return versions.randomElement()!
    }
}

