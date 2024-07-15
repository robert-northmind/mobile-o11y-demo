import 'package:equatable/equatable.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_info.dart';

class Car extends Equatable {
  const Car({
    required this.info,
    required this.doorStatus,
  });

  final CarInfo info;
  final CarDoorStatus doorStatus;

  @override
  List<Object?> get props => [info, doorStatus];
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
