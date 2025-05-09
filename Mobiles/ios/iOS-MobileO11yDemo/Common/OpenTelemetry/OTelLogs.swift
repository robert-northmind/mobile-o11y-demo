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
import FaroOtelExporter

class OTelLogs {
    static let instance = OTelLogs()
    
    private init() {}
    
    private var isInitialized = false
    
    func initialize() {
        guard isInitialized == false else { return }
        isInitialized = true

        // -- Pure Otel exporter --
        let urlConfig = URLSessionConfiguration.default
        urlConfig.httpAdditionalHeaders = OTelAuthProvider().getAuthHeader()
        let otlpHttpLogExporter = OtlpHttpLogExporter(
            endpoint: URL(string: "\(OTelConfig().endpointUrl)/v1/logs")!,
            useSession: URLSession(configuration: urlConfig)
        )
        // Use `SimpleLogRecordProcessor` during development.
        let otelLogProcessor = SimpleLogRecordProcessor(logRecordExporter:otlpHttpLogExporter)
        
        // -- Faro exporter --
        let faroOptions = FaroExporterOptions(
            collectorUrl: FaroConfig().collectorUrl,
            appName: "mobile-o11y-flutter-demo-app",
            appVersion: "1.0.0",
            appEnvironment: "production",
        )
        let faroLogExporter = try! FaroExporter(options: faroOptions)
        let faroLogProcessor = BatchLogRecordProcessor(logRecordExporter:faroLogExporter)

        let loggerProvider = LoggerProviderBuilder()
                    .with(processors: [faroLogProcessor])
                    .with(resource: OTelResourceProvider().getResource())
                    .build()
        OpenTelemetry.registerLoggerProvider(loggerProvider: loggerProvider)
    }

    func getLogger() -> OpenTelemetryApi.Logger {
        let otelConfig = OTelConfig()
        return OpenTelemetry.instance.loggerProvider.loggerBuilder(
            instrumentationScopeName: otelConfig.instrumentationScopeName
        ).setEventDomain("ios-device").build()
    }
}

extension OpenTelemetryApi.Logger {
    func log(
        _ message: String,
        severity: Severity,
        timestamp: Date = Date(),
        attributes: [String: String] = [:]
    ) {
        var otelAttributes = attributes.reduce(into: [String: OpenTelemetryApi.AttributeValue]()) {
            $0[$1.key] = OpenTelemetryApi.AttributeValue.string($1.value)
        }
        self
            .logRecordBuilder()
            .setBody(OpenTelemetryApi.AttributeValue.string(message))
            .setTimestamp(timestamp)
            .setAttributes(otelAttributes)
            .setSeverity(severity)
            .emit()
    }
}
