import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_door_status.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/error_presenter.dart';
import 'package:rxdart/rxdart.dart';

class CarDoorActionService {
  CarDoorActionService({
    required SelectedCarService selectedCarService,
    required CarCommunication carCommunication,
    required ErrorPresenter errorPresenter,
  })  : _selectedCarService = selectedCarService,
        _carCommunication = carCommunication,
        _errorPresenter = errorPresenter;

  final SelectedCarService _selectedCarService;
  final CarCommunication _carCommunication;
  final ErrorPresenter _errorPresenter;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  bool get isLoading => _isLoadingSubject.value;

  void dispose() {
    _isLoadingSubject.close();
  }

  Future<void> lockCar() async {
    await _setDoorLockState(shouldLock: true);
  }

  Future<void> unlockCar() async {
    await _setDoorLockState(shouldLock: false);
  }

  Future<void> _setDoorLockState({required bool shouldLock}) async {
    final car = _selectedCarService.car;
    if (car == null) {
      // No car. Cannot do anything.
      return;
    }

    _isLoadingSubject.value = true;

    try {
      if (shouldLock) {
        await _carCommunication.lockDoors();
      } else {
        await _carCommunication.unlockDoors();
      }
      _updateCar(car: car, isLocked: shouldLock);
    } catch (error) {
      _errorPresenter.presentError(
        'CarDoorActionService failed with error: $error',
      );
    }
    _isLoadingSubject.value = false;
  }

  Future<void> _updateCar({required Car car, required bool isLocked}) async {
    final updatedCar = Car(
      info: car.info,
      doorStatus: CarDoorStatus(isLocked: isLocked),
    );
    _selectedCarService.updateSelectedCar(updatedCar);
  }
}
