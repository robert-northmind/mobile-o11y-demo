import 'dart:async';

import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/local_o11y/local_tracer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final o11yTracesProvider = Provider((ref) {
  // return LocalO11yTraces();

  return O11yTraces(
    faro: ref.watch(faroProvider),
  );
});

class O11yTraces {
  O11yTraces({
    required Faro faro,
  }) : _faro = faro;

  final Faro _faro;

  FutureOr<T> startSpan<T>(
    String name,
    FutureOr<T> Function(Span) body, {
    Map<String, String> attributes = const {},
    Span? parentSpan,
  }) async {
    return _faro.startSpan(
      name,
      body,
      attributes: attributes,
      parentSpan: parentSpan,
    );
  }

  Span startSpanManual(
    String name, {
    Map<String, String> attributes = const {},
    Span? parentSpan,
  }) {
    return _faro.startSpanManual(
      name,
      attributes: attributes,
      parentSpan: parentSpan,
    );
  }

  Span? getActiveSpan() {
    return _faro.getActiveSpan();
  }
}
