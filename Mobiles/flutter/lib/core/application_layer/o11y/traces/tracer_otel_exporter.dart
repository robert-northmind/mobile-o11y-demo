// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opentelemetry/sdk.dart';

final tracerOtelExporterFactoryProvider = Provider((ref) {
  return TracerOtelExporterFactory();
});

class TracerOtelExporterFactory {
  CollectorExporter getOtelExporter() {
    final otelHeaders = dotenv.env['OTEL_EXPORTER_OTLP_HEADERS'];
    final endpointUrl = dotenv.env['OTEL_EXPORTER_OTLP_ENDPOINT'];

    if (endpointUrl == null || otelHeaders == null) {
      throw Exception(
        'OTEL_EXPORTER_OTLP_HEADERS or OTEL_EXPORTER_OTLP_ENDPOINT not found in .env',
      );
    }

    return CollectorExporter(
      Uri.parse('$endpointUrl/v1/traces'),
      headers: {'Authorization': otelHeaders},
    );
  }
}
