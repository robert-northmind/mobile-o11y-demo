// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:flutter_mobile_o11y_demo/core/car/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/car/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_door_status.dart';
import 'package:rxdart/rxdart.dart';

class CarDoorActionService {
  CarDoorActionService({
    required SelectedCarService selectedCarService,
    required CarCommunication carCommunication,
  })  : _selectedCarService = selectedCarService,
        _carCommunication = carCommunication;

  final SelectedCarService _selectedCarService;
  final CarCommunication _carCommunication;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  bool get isLoading => _isLoadingSubject.value;

  void dispose() {
    _isLoadingSubject.close();
  }

  Future<void> lockCar() async {
    final car = _selectedCarService.car;
    if (car == null) {
      // No car. Cannot do anything.
      return;
    }

    _isLoadingSubject.value = true;
    await _carCommunication.lockDoors();
    _updateCar(
      car: car,
      shouldLock: true,
    );
    _isLoadingSubject.value = false;
  }

  Future<void> unlockCar() async {
    final car = _selectedCarService.car;
    if (car == null) {
      // No car. Cannot do anything.
      return;
    }

    _isLoadingSubject.value = true;
    await _carCommunication.unlockDoors();
    _updateCar(
      car: car,
      shouldLock: false,
    );
    _isLoadingSubject.value = false;
  }

  Future<void> _updateCar({
    required Car car,
    required bool shouldLock,
  }) async {
    final updatedCar = Car(
      info: car.info,
      doorStatus: CarDoorStatus(isLocked: shouldLock ? true : false),
    );
    _selectedCarService.updateSelectedCar(updatedCar);
  }
}
