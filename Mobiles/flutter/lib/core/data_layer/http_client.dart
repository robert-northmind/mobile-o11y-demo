// ignore_for_file: cascade_invocations

import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_span.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_tracer.dart';
import 'package:flutter_mobile_o11y_demo/core/data_layer/models/http_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider((ref) {
  return HttpClient(
    baseUrl: 'localhost:3000',
    tracer: ref.watch(o11yTracerProvider),
  );
});

class HttpClient {
  HttpClient({
    required String baseUrl,
    required O11yTracer tracer,
  })  : _baseUrl = baseUrl,
        _tracer = tracer {
    _client = http.Client();
  }

  final String _baseUrl;
  late final http.Client _client;
  final O11yTracer _tracer;

  Future<HttpResponse> get(String endpoint) async {
    return _tracer.executeWithParentSpan(work: () async {
      final span = _tracer.startSpan('HTTP GET');
      final uri = Uri.http(_baseUrl, endpoint);

      try {
        final response = await _client.get(uri);
        span.setStatus(StatusCode.ok);
        return HttpResponse(
          statusCode: response.statusCode,
          body: response.body,
        );
      } catch (error) {
        span.setStatus(StatusCode.error, message: error.toString());
        rethrow;
      } finally {
        span.end();
      }
    });
  }

  Future<HttpResponse> post(String endpoint, dynamic body) async {
    return _tracer.executeWithParentSpan(work: () async {
      final span = _tracer.startSpan('HTTP POST');

      final uri = Uri.http(_baseUrl, endpoint);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'traceparent': span.toHttpTraceparent(),
      };

      try {
        final response = await _client.post(uri, body: body, headers: headers);
        span.setStatus(StatusCode.ok);
        return HttpResponse(
          statusCode: response.statusCode,
          body: response.body,
        );
      } catch (error) {
        span.setStatus(StatusCode.error, message: error.toString());
        rethrow;
      } finally {
        span.end();
      }
    });
  }
}
