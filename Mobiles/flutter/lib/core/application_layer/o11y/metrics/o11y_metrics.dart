import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/local_o11y/local_metrics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final o11yMetricsProvider = Provider((ref) {
  return LocalO11yMetrics();

  return O11yMetrics(
    faro: ref.watch(faroProvider),
  );
});

class O11yMetrics {
  O11yMetrics({
    required Faro faro,
  }) : _faro = faro;

  final Faro _faro;

  void addMeasurement(String name, Map<String, dynamic> values) {
    _faro.pushMeasurement(values, name);
  }
}
