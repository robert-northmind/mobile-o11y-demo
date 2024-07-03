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

class OTelTraces {
    static let instance = OTelTraces()
    
    private init() {}
    
    private var isInitialized = false

    func initialize() {
        guard isInitialized == false else { return }
        isInitialized = true

        let urlConfig = URLSessionConfiguration.default
        urlConfig.httpAdditionalHeaders = OTelAuthProvider().getAuthHeader()
        
        let otlpHttpTraceExporter = OtlpHttpTraceExporter(
            endpoint: URL(string: "\(OTelConfig().endpointUrl)/v1/traces")!,
            useSession: URLSession(configuration: urlConfig)
        )
        
//        let stdoutProcessor = SimpleSpanProcessor(spanExporter: StdoutExporter())
        let otlpHttpTraceProcessor = SimpleSpanProcessor(spanExporter: otlpHttpTraceExporter)
//        let otlpHttpTraceProcessor = BatchSpanProcessor(spanExporter: otlpHttpTraceExporter)
        
        let tracerProvider = TracerProviderBuilder()
//            .add(spanProcessor: stdoutProcessor)
            .add(spanProcessor: otlpHttpTraceProcessor)
            .with(resource: OTelResourceProvider().getResource())
            .build()
        OpenTelemetry.registerTracerProvider(tracerProvider:tracerProvider)
        
        let otelEndpointUrl = URL(string: "\(OTelConfig().endpointUrl)/v1/traces")!,
        _ = URLSessionInstrumentation(
            configuration: URLSessionInstrumentationConfiguration(
                shouldInstrument: { request in
                    // Only instrument legitimate API calls and not the calls to the APM collector
                    if request.url?.host() == otelEndpointUrl.host() {
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

