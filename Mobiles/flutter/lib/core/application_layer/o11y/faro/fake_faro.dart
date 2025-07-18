// ignore_for_file: implementation_imports

import 'dart:async';

import 'package:faro/faro.dart';
import 'package:faro/src/data_collection_policy.dart';
import 'package:faro/src/native_platform_interaction/faro_native_methods.dart';
import 'package:faro/src/transport/batch_transport.dart';
import 'package:faro/src/transport/faro_base_transport.dart';

class FakeFaro implements Faro {
  @override
  FaroConfig? config;

  @override
  bool enableDataCollection = false;

  @override
  Map<String, dynamic> eventMark = {};

  @override
  List<RegExp>? ignoreUrls;

  @override
  Meta meta = Meta();

  @override
  FaroNativeMethods? nativeChannel;

  @override
  List<BaseTransport> transports = [];

  @override
  set batchTransport(BatchTransport? batchTransport) {}

  @override
  set dataCollectionPolicy(DataCollectionPolicy? policy) {}

  @override
  Future<void>? enableCrashReporter(
      {required App app,
      required String apiKey,
      required String collectorUrl}) async {}

  @override
  Span? getActiveSpan() {
    return null;
  }

  @override
  Future<void> init({required FaroConfig optionsConfiguration}) async {}

  @override
  void markEventEnd(String key, String name,
      {Map<String, dynamic> attributes = const {}}) {}

  @override
  void markEventStart(String key, String name) {}

  @override
  void pushError(
      {required String type,
      required String value,
      StackTrace? stacktrace,
      Map<String, String>? context}) {
    print('FakeFaro: pushError: $type, $value, $stacktrace, $context');
  }

  @override
  void pushEvent(String name,
      {Map<String, dynamic>? attributes, Map<String, String>? trace}) {
    print('FakeFaro: pushEvent: $name, $attributes, $trace');
  }

  @override
  void pushLog(String message,
      {required LogLevel level,
      Map<String, dynamic>? context,
      Map<String, String>? trace}) {
    print('FakeFaro: pushLog: $message, $level, $context, $trace');
  }

  @override
  void pushMeasurement(Map<String, dynamic>? values, String type) {
    print('FakeFaro: pushMeasurement: $values, $type');
  }

  @override
  Future<void> runApp(
      {required FaroConfig optionsConfiguration,
      required AppRunner? appRunner}) async {}

  @override
  void setAppMeta(
      {required String appName,
      required String appEnv,
      required String appVersion,
      required String? namespace}) {}

  @override
  void setUserMeta({String? userId, String? userName, String? userEmail}) {
    print('FakeFaro: setUserMeta: $userId, $userName, $userEmail');
  }

  @override
  void setViewMeta({String? name}) {
    print('FakeFaro: setViewMeta: $name');
  }

  @override
  FutureOr<T> startSpan<T>(String name, FutureOr<T> Function(Span p1) body,
      {Map<String, String> attributes = const {}, Span? parentSpan}) {
    print('FakeFaro: startSpan: $name, $attributes, $parentSpan');
    return body(LocalSpan());
  }

  @override
  Span startSpanManual(String name,
      {Map<String, String> attributes = const {}, Span? parentSpan}) {
    print('FakeFaro: startSpanManual: $name, $attributes, $parentSpan');
    return LocalSpan();
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

  @override
  bool get statusHasBeenSet => false;
}
