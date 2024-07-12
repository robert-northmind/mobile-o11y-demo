import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/car_connection_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
CarConnectionService carConnectionService(
  CarConnectionServiceRef ref,
) {
  final service = CarConnectionService(
    carFactory: ref.read(carFactoryProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}
