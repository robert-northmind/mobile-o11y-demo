import 'package:flutter_mobile_o11y_demo/core/car/application_layer/car_communication/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/car/application_layer/selected_car/providers.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation/dialogs/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/car_connection_service.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/car_door_action_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
CarConnectionService carConnectionService(
  CarConnectionServiceRef ref,
) {
  final service = CarConnectionService(
    carCommunication: ref.watch(carCommunicationProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
CarDoorActionService carDoorActionService(
  CarDoorActionServiceRef ref,
) {
  return CarDoorActionService(
    carCommunication: ref.watch(carCommunicationProvider),
    selectedCarService: ref.watch(selectedCarServiceProvider),
    errorPresenter: ref.watch(errorPresenterProvider),
  );
}
