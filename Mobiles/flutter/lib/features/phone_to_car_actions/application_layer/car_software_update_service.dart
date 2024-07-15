import 'dart:async';

import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_info.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_software_version.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/error_presenter.dart';
import 'package:rxdart/rxdart.dart';

class CarSoftwareUpdateService {
  CarSoftwareUpdateService({
    required CarCommunication carCommunication,
    required SelectedCarService selectedCarService,
    required CarSoftwareVersionFactory carSoftwareVersionFactory,
    required ErrorPresenter errorPresenter,
  })  : _carCommunication = carCommunication,
        _selectedCarService = selectedCarService,
        _carSoftwareVersionFactory = carSoftwareVersionFactory,
        _errorPresenter = errorPresenter {
    _setupNextSoftwareVersionListener();
    _setupUpdateProgressListener();
  }

  final CarCommunication _carCommunication;
  final SelectedCarService _selectedCarService;
  final CarSoftwareVersionFactory _carSoftwareVersionFactory;
  final ErrorPresenter _errorPresenter;

  final List<StreamSubscription> _subscriptions = [];

  final _newSoftwareVersionSubject =
      BehaviorSubject<CarSoftwareVersion?>.seeded(null);
  final _updateProgressSubject = BehaviorSubject<double>.seeded(0);
  final _inProgressSubject = BehaviorSubject<bool>.seeded(false);

  Stream<CarSoftwareVersion?> get newSoftwareVersionStream =>
      _newSoftwareVersionSubject.stream;
  CarSoftwareVersion? get newSoftwareVersion =>
      _newSoftwareVersionSubject.value;

  Stream<double> get updateProgressStream => _updateProgressSubject.stream;
  double get updateProgress => _updateProgressSubject.value;

  Stream<bool> get inProgressStream => _inProgressSubject.stream;
  bool get inProgress => _inProgressSubject.value;

  Future<void> updateSoftware() async {
    final car = _selectedCarService.car;
    final nextVersion = newSoftwareVersion;
    if (nextVersion == null || car == null) {
      // No software version or no car. Cannot do anything.
      return;
    }

    _inProgressSubject.add(true);

    try {
      await _carCommunication.updateSoftware(nextVersion);
      _updateCar(car: car, newSoftwareVersion: nextVersion);
    } catch (error) {
      _errorPresenter.presentError(
        'CarSoftwareUpdateService failed with error: $error',
      );
    }

    _inProgressSubject.add(false);
  }

  void dispose() {
    _newSoftwareVersionSubject.close();
    _updateProgressSubject.close();
    _inProgressSubject.close();
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
  }

  void _setupNextSoftwareVersionListener() {
    final subscription = _selectedCarService.carStream.listen((car) {
      if (car != null) {
        final currentVersion = car.info.softwareVersion;
        final nextVersion = _carSoftwareVersionFactory.getRandomNextVersion(
          currentVersion: currentVersion,
        );
        _newSoftwareVersionSubject.add(nextVersion);
      }
    });
    _subscriptions.add(subscription);
  }

  void _setupUpdateProgressListener() {
    final subscription = _carCommunication.softwareUpdateProgressStream.listen(
      _updateProgressSubject.add,
    );
    _subscriptions.add(subscription);
  }

  Future<void> _updateCar({
    required Car car,
    required CarSoftwareVersion newSoftwareVersion,
  }) async {
    final info = CarInfo(
      vin: car.info.vin,
      color: car.info.color,
      model: car.info.model,
      productionDate: car.info.productionDate,
      softwareVersion: newSoftwareVersion,
    );
    final updatedCar = Car(
      info: info,
      doorStatus: car.doorStatus,
    );
    _selectedCarService.updateSelectedCar(updatedCar);
  }
}
