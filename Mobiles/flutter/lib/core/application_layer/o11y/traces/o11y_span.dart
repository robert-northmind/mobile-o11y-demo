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

  void end() {
    otelSpan.end();
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
