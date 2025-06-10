import 'package:faro/faro_sdk.dart';

class LocalTracer implements Tracer {
  @override
  Span startSpan(String name,
      {bool isActive = false,
      Span? parentSpan,
      Map<String, dynamic> attributes = const {}}) {
    print('LocalTracer: startSpan: $name, $attributes');
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
  void setStatus(SpanStatusCode statusCode, {String? message}) {
    print('LocalSpan: setStatus: $statusCode, $message');
  }

  @override
  String get spanId => '123';

  @override
  String get traceId => '456';

  @override
  bool get wasEnded => false;
}
