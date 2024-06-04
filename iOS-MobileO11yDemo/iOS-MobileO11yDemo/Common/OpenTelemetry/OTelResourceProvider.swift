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
    func getResource() -> Resource {
        let otelConfig = OTelConfig()
        let defaultResources = DefaultResources().get()
        let customResource = Resource(
            attributes: [
                "service.name": AttributeValue.string(otelConfig.serviceName),
                "deployment.environment": AttributeValue.string(otelConfig.deploymentEnvironment),
                "service.version": AttributeValue.string("1.0.0"),
            ]
        )
        return defaultResources.merging(other: customResource)
    }
}

