//
//  OTelTraces.swift
//  iOS-MobileO11yDemo
//
//  Created by Robert Magnusson on 16.05.24.
//

import Foundation
import OpenTelemetryApi
import OpenTelemetrySdk
import StdoutExporter
import OpenTelemetryProtocolExporterHttp
import URLSessionInstrumentation
import FaroOtelExporter

class OTelTraces {
    static let instance = OTelTraces()
    
    private init() {}
    
    private var isInitialized = false

    func initialize() {
        guard isInitialized == false else { return }
        isInitialized = true
        
        // -- Pure Otel exporter --
        let urlConfig = URLSessionConfiguration.default
        urlConfig.httpAdditionalHeaders = OTelAuthProvider().getAuthHeader()
        let otlpHttpTraceExporter = OtlpHttpTraceExporter(
            endpoint: URL(string: "\(OTelConfig().endpointUrl)/v1/traces")!,
            useSession: URLSession(configuration: urlConfig)
        )
        let otlpHttpTraceProcessor = SimpleSpanProcessor(spanExporter: otlpHttpTraceExporter)
//        let otlpHttpTraceProcessor = BatchSpanProcessor(spanExporter: otlpHttpTraceExporter)

        // -- Faro exporter --
        let faroOptions = FaroExporterOptions(
            collectorUrl: FaroConfig().collectorUrl,
            appName: "mobile-o11y-flutter-demo-app",
            appVersion: "1.0.0",
            appEnvironment: "production",
        )
        let faroExporter = try! FaroExporter(options: faroOptions)
        let faroProcessor = BatchSpanProcessor(spanExporter:faroExporter)
        
        let tracerProvider = TracerProviderBuilder()
            .add(spanProcessor: faroProcessor)
            .with(resource: OTelResourceProvider().getResource())
            .build()
        OpenTelemetry.registerTracerProvider(tracerProvider:tracerProvider)
        
        let otelEndpointUrl = URL(string: "\(OTelConfig().endpointUrl)/v1/traces")!
        let faroEndpointUrl = URL(string: faroOptions.collectorUrl)!
        _ = URLSessionInstrumentation(
            configuration: URLSessionInstrumentationConfiguration(
                shouldInstrument: { request in
                    // Only instrument legitimate API calls and not the calls to the APM collector
                    if request.url?.host() == otelEndpointUrl.host() {
                        return false
                    }
                    if request.url?.host() == faroEndpointUrl.host() {
                        return false
                    }
                    return true
                },
                spanCustomization: { (request, spanBuilder) in
                    spanBuilder.setSpanKind(spanKind: .client)
                }
            )
        )
    }

    func getTracer() -> Tracer {
        let otelConfig = OTelConfig()
        return OpenTelemetry.instance.tracerProvider.get(
            instrumentationName: otelConfig.instrumentationScopeName,
            instrumentationVersion: otelConfig.instrumentationScopeVersion
        )
    }
}

