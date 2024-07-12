import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_info.dart';

class Car {
  const Car({
    required this.info,
    required this.doorStatus,
  });

  final CarInfo info;
  final CarDoorStatus doorStatus;
}

class CarFactory {
  CarFactory({
    required this.carInfoFactory,
  });

  final CarInfoFactory carInfoFactory;

  Car getRandomCar() {
    return Car(
      info: carInfoFactory.getRandomCarInfo(),
      doorStatus: const CarDoorStatus(isLocked: false),
    );
  }
}
