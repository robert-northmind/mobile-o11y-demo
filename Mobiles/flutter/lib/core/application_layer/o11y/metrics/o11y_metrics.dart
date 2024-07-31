import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/faro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rum_sdk/rum_flutter.dart';
import 'package:rum_sdk/rum_sdk.dart';

final o11yMetricsProvider = Provider((ref) {
  return O11yMetrics(
    rumFlutter: ref.watch(rumProvider),
  );
});

class O11yMetrics {
  O11yMetrics({
    required RumFlutter rumFlutter,
  }) : _rumFlutter = rumFlutter;

  final RumFlutter _rumFlutter;

  Future<void> addMeasurement(
    String name,
    Map<String, dynamic> values,
  ) async {
    await _rumFlutter.pushMeasurement(values, name);
  }
}
