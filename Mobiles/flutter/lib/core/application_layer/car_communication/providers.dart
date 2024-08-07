import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/fake_car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
CarCommunication carCommunication(
  CarCommunicationRef ref,
) {
  return FakeCarCommunication(
    logger: ref.watch(o11yLoggerProvider),
  );
}
