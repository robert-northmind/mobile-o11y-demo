class HttpResponse {
  HttpResponse({
    required this.statusCode,
    required this.body,
  });

  final int statusCode;
  final String body;
}
