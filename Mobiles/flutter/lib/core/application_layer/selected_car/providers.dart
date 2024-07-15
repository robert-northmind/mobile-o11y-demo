import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
SelectedCarService selectedCarService(
  SelectedCarServiceRef ref,
) {
  final service = SelectedCarService(
    carFactory: ref.read(carFactoryProvider),
  );
  ref.onDispose(service.dispose);
  return service;
}

@riverpod
Car? selectedCar(
  SelectedCarRef ref,
) {
  final selectedCarService = ref.watch(selectedCarServiceProvider);
  final subscription = selectedCarService.carStream.skip(1).listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  return selectedCarService.car;
}
