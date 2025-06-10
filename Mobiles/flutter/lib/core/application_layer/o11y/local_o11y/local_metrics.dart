import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/metrics/o11y_metrics.dart';

class LocalO11yMetrics implements O11yMetrics {
  @override
  Future<void> addMeasurement(String name, Map<String, dynamic> values) async {
    print('LocalO11yMetrics: addMeasurement: $name, $values');
  }
}
