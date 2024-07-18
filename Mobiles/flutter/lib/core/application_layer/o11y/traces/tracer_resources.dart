import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opentelemetry/api.dart';
import 'package:opentelemetry/sdk.dart';

final tracerResourcesFactoryProvider = Provider((ref) {
  return TracerResourcesFactory();
});

class TracerResourcesFactory {
  Resource getTracerResource() {
    return Resource(
      [
        Attribute.fromString(
          ResourceAttributes.serviceName,
          'mobile-o11y-flutter-demo-app',
        ),
        Attribute.fromString(
          ResourceAttributes.deploymentEnvironment,
          'production',
        ),
        Attribute.fromString(
          ResourceAttributes.serviceVersion,
          '1.0.0',
        ),
        Attribute.fromString('telemetry.sdk.name', 'opentelemetry-dart'),
        Attribute.fromString('telemetry.sdk.language', 'dart'),
        Attribute.fromString('telemetry.sdk.version', '0.18.3'),
      ],
    );
  }
}
