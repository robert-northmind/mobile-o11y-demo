import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_info.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_software_version.dart';
import 'package:flutter_mobile_o11y_demo/core/utils/random_element.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
CarFactory carFactory(
  CarFactoryRef ref,
) {
  return CarFactory(
    carInfoFactory: ref.read(carInfoFactoryProvider),
  );
}

@riverpod
CarInfoFactory carInfoFactory(
  CarInfoFactoryRef ref,
) {
  return CarInfoFactory(
    carSoftwareVersionFactory: ref.read(carSoftwareVersionFactoryProvider),
    randomVinFactory: RandomVinFactory(),
  );
}

@riverpod
CarSoftwareVersionFactory carSoftwareVersionFactory(
  CarSoftwareVersionFactoryRef ref,
) {
  return CarSoftwareVersionFactory();
}
