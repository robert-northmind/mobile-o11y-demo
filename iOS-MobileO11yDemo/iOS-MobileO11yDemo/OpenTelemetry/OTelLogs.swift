//
//  OTelLogs.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk
import OpenTelemetryProtocolExporterHttp

class OTelLogs {
    static let instance = OTelLogs()
    
    private init() {}
    
    private var isInitialized = false
    
    func initialize() {
        guard isInitialized == false else { return }
        isInitialized = true

        let urlConfig = URLSessionConfiguration.default
        urlConfig.httpAdditionalHeaders = OTelAuthProvider().getAuthHeader()
        
        let otlpHttpLogExporter = OtlpHttpLogExporter(
            endpoint: URL(string: "\(OTelConfig().endpointUrl)/v1/logs")!,
            useSession: URLSession(configuration: urlConfig)
        )
        
        // Use `SimpleLogRecordProcessor` during development.
//        let logProcessor = SimpleLogRecordProcessor(logRecordExporter:otlpHttpLogExporter)
        
        // Use `BatchSpanProcessor` for production.
        let logProcessor = BatchLogRecordProcessor(logRecordExporter:otlpHttpLogExporter)
        
        let loggerProvider = LoggerProviderBuilder()
                    .with(processors: [logProcessor])
                    .with(resource: OTelResourceProvider().getResource())
                    .build()
        OpenTelemetry.registerLoggerProvider(loggerProvider: loggerProvider)
    }

    func getLogger() -> Logger {
        let otelConfig = OTelConfig()
        return OpenTelemetry.instance.loggerProvider.loggerBuilder(
            instrumentationScopeName: otelConfig.instrumentationScopeName
        ).setEventDomain("ios-device").build()
    }
}

extension Logger {
    func log(
        _ message: String,
        severity: Severity,
        timestamp: Date = Date(),
        attributes: [String: String] = [:]
    ) {
        let otelAttributes = attributes.reduce(into: [String: AttributeValue]()) {
            $0[$1.key] = AttributeValue.string($1.value)
        }
        self
            .logRecordBuilder()
            .setBody(AttributeValue.string(message))
            .setTimestamp(timestamp)
            .setAttributes(otelAttributes)
            .setSeverity(severity)
            .emit()
    }
}
