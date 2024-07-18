import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opentelemetry/api.dart' as api;

final o11ySpanFactoryProvider = Provider((ref) {
  return O11ySpanFactory();
});

class O11ySpanFactory {
  O11ySpan getSpan({required api.Span otelSpan}) {
    return O11ySpan(otelSpan: otelSpan);
  }
}

class O11ySpan {
  O11ySpan({required this.otelSpan});

  final api.Span otelSpan;

  void setStatus(StatusCode statusCode, {String? message}) {
    if (message != null) {
      otelSpan.setStatus(statusCode.toOtelStatusCode(), message);
    } else {
      otelSpan.setStatus(statusCode.toOtelStatusCode());
    }
  }

  void addEvent(String message, {Map<String, String> attributes = const {}}) {
    final listAttributes = attributes.entries.map((entry) {
      return api.Attribute.fromString(entry.key, entry.value);
    }).toList();
    otelSpan.addEvent(message, attributes: listAttributes);
  }

  void setAttributes(Map<String, String> attributes) {
    final listAttributes = attributes.entries.map((entry) {
      return api.Attribute.fromString(entry.key, entry.value);
    }).toList();
    otelSpan.setAttributes(listAttributes);
  }

  void end() {
    otelSpan.end();
  }

  String toHttpTraceparent() {
    // W3CTraceContextPropagator stuff.
    // Copied from the OtelSift implementation
    // https://github.com/open-telemetry/opentelemetry-swift/blob/7bad8ae7f230e7a1b9ec697f36dcae91a8debff9/Sources/OpenTelemetryApi/Trace/Propagation/W3CTraceContextPropagator.swift
    const version = '00';
    const delimiter = '-';
    final traceId = otelSpan.spanContext.traceId.toString();
    final spanId = otelSpan.spanContext.spanId.toString();
    const endString = '01';
    final traceparent =
        '$version$delimiter$traceId$delimiter$spanId$delimiter$endString';
    return traceparent;
  }
}

enum StatusCode {
  /// The default status.
  unset,

  /// The operation contains an error.
  error,

  /// The operation has been validated by an Application developers or
  /// Operator to have completed successfully.
  ok,
}

extension StatusCodeX on StatusCode {
  api.StatusCode toOtelStatusCode() {
    switch (this) {
      case StatusCode.unset:
        return api.StatusCode.unset;
      case StatusCode.error:
        return api.StatusCode.error;
      case StatusCode.ok:
        return api.StatusCode.ok;
    }
  }
}
