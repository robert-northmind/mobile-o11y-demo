import 'package:flutter_mobile_o11y_demo/core/car/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/car/application_layer/car_communication/fake_car_communication.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
CarCommunication carCommunication(
  CarCommunicationRef ref,
) {
  return FakeCarCommunication();
}
