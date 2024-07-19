import 'dart:async';

import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_span.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/tracer_otel_exporter.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/tracer_resources.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart' as otel_sdk;

final o11yTracerProvider = Provider((ref) {
  return O11yTracer(
    otelExporterFactory: ref.watch(tracerOtelExporterFactoryProvider),
    resourcesFactory: ref.watch(tracerResourcesFactoryProvider),
    o11ySpanFactory: ref.watch(o11ySpanFactoryProvider),
  );
});

class O11yTracer {
  O11yTracer({
    required TracerOtelExporterFactory otelExporterFactory,
    required TracerResourcesFactory resourcesFactory,
    required O11ySpanFactory o11ySpanFactory,
  })  : _otelExporterFactory = otelExporterFactory,
        _resourcesFactory = resourcesFactory,
        _o11ySpanFactory = o11ySpanFactory {
    setup();
  }

  final TracerOtelExporterFactory _otelExporterFactory;
  final TracerResourcesFactory _resourcesFactory;
  final O11ySpanFactory _o11ySpanFactory;

  late final Tracer _tracer;
  O11ySpan? activeSpan;

  O11ySpan startSpan(String name, {bool isActive = false}) {
    final otelSpan = _tracer.startSpan(name, kind: SpanKind.server);
    final ollySpan = _o11ySpanFactory.getSpan(otelSpan: otelSpan);
    if (isActive) {
      activeSpan = ollySpan;
    }
    return ollySpan;
  }

  Future<T> executeWithParentSpan<T>({
    O11ySpan? parentSpan,
    required FutureOr<T> Function() work,
  }) async {
    final completer = Completer<T>();
    final parentO11ySpan = parentSpan ?? activeSpan;
    final parent = parentO11ySpan?.otelSpan ?? Context.current.span;
    Context.current.withSpan(parent).execute(() async {
      final result = await work();
      completer.complete(result);
    });
    return completer.future;
  }

  void setup() {
    final exporter = _otelExporterFactory.getOtelExporter();
    final resource = _resourcesFactory.getTracerResource();

    final provider = otel_sdk.TracerProviderBase(
      resource: resource,
      processors: [
        // otel_sdk.SimpleSpanProcessor(exporter),
        otel_sdk.BatchSpanProcessor(exporter),
        // otel_sdk.SimpleSpanProcessor(otel_sdk.ConsoleExporter())
      ],
    );

    registerGlobalTracerProvider(provider);

    _tracer = provider.getTracer('main-instrumentation');
  }
}
