// ignore_for_file: cascade_invocations

import 'dart:io';

import 'package:flutter_mobile_o11y_demo/core/data_layer/models/http_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider((ref) {
  if (Platform.isAndroid) {
    // When running an Android emulator, localhost or 127.0.0.1
    // within the emulator refers to the emulator’s own loopback address,
    // not your machine’s localhost. The Android emulator provides a special IP
    // address that redirects to your local machine’s localhost.
    // That is this '10.0.2.2'
    return HttpClient(baseUrl: '10.0.2.2:3000');
  } else {
    return HttpClient(baseUrl: 'localhost:3000');
  }
});

class HttpClient {
  HttpClient({required String baseUrl}) : _baseUrl = baseUrl {
    _client = http.Client();
  }

  final String _baseUrl;
  late final http.Client _client;

  Future<HttpResponse> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.http(_baseUrl, endpoint);
    final response = await _client.get(uri, headers: headers);
    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }

  Future<HttpResponse> post(
    String endpoint,
    dynamic body, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.http(_baseUrl, endpoint);
    final allHeaders = <String, String>{
      'Content-Type': 'application/json',
      ...?headers,
    };
    final response = await _client.post(uri, body: body, headers: allHeaders);
    return HttpResponse(
      statusCode: response.statusCode,
      body: response.body,
    );
  }
}
