import 'dart:async';

import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_traces.dart';

class LocalO11yTraces implements O11yTraces {
  @override
  Span? getActiveSpan() {
    return null;
  }

  @override
  Span startSpanManual(String name,
      {Map<String, String> attributes = const {}, Span? parentSpan}) {
    return LocalSpan();
  }

  @override
  FutureOr<T> startSpan<T>(String name, FutureOr<T> Function(Span span) body,
      {Map<String, String> attributes = const {}, Span? parentSpan}) {
    return body(LocalSpan());
  }
}

class LocalSpan implements Span {
  @override
  void addEvent(String message, {Map<String, String> attributes = const {}}) {
    print('LocalSpan: addEvent: $message, $attributes');
  }

  @override
  void end() {
    print('LocalSpan: end');
  }

  @override
  void setAttributes(Map<String, String> attributes) {
    print('LocalSpan: setAttributes: $attributes');
  }

  @override
  void setAttribute(String key, String value) {
    print('LocalSpan: setAttribute: $key, $value');
  }

  @override
  void setStatus(SpanStatusCode statusCode, {String? message}) {
    print('LocalSpan: setStatus: $statusCode, $message');
  }

  @override
  void recordException(exception, {StackTrace? stackTrace}) {
    print('LocalSpan: recordException: $exception, $stackTrace');
  }

  @override
  String get spanId => '123';

  @override
  String get traceId => '456';

  @override
  bool get wasEnded => false;

  @override
  SpanStatusCode get status => SpanStatusCode.unset;
}
