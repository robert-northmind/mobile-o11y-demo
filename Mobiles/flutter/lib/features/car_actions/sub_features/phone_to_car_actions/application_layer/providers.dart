import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/application_layer/car_connection_service.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/application_layer/car_connection_tracer.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/application_layer/car_door_action_service.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/application_layer/car_software_update_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
CarConnectionService carConnectionService(
  CarConnectionServiceRef ref,
) {
  final service = CarConnectionService(
    carCommunication: ref.watch(carCommunicationProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
    tracer: ref.watch(carConnectionTracerProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
CarDoorActionService carDoorActionService(
  CarDoorActionServiceRef ref,
) {
  final service = CarDoorActionService(
    carCommunication: ref.watch(carCommunicationProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
    errorPresenter: ref.watch(errorPresenterProvider),
    tracer: ref.watch(carConnectionTracerProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}

@Riverpod(keepAlive: true)
CarSoftwareUpdateService carSoftwareUpdateService(
  CarSoftwareUpdateServiceRef ref,
) {
  final service = CarSoftwareUpdateService(
    carCommunication: ref.watch(carCommunicationProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
    carSoftwareVersionFactory: ref.read(carSoftwareVersionFactoryProvider),
    errorPresenter: ref.read(errorPresenterProvider),
    tracer: ref.watch(carConnectionTracerProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
Car? getConnectedCar(
  GetConnectedCarRef ref,
) {
  final carConnectionService = ref.watch(carConnectionServiceProvider);
  final subscription = carConnectionService.carStream.skip(1).listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  return carConnectionService.car;
}
