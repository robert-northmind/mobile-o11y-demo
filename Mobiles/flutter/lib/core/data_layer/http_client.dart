import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final httpClientProvider = Provider((ref) {
  return HttpClient(baseUrl: 'localhost:3000');
});

class HttpClient {
  HttpClient({
    required String baseUrl,
  }) : _baseUrl = baseUrl {
    _client = http.Client();
  }

  final String _baseUrl;
  late final http.Client _client;

  Future<http.Response> get(String endpoint) async {
    final uri = Uri.http(_baseUrl, endpoint);
    return _client.get(uri);
  }

  // TODO: Abstract away the resposne type here!
  Future<http.Response> post(String endpoint, dynamic body) async {
    final uri = Uri.http(_baseUrl, endpoint);
    return _client.post(uri, body: body);
  }
}
