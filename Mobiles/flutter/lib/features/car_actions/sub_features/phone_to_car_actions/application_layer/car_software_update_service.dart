// ignore_for_file: lines_longer_than_80_chars, cascade_invocations

import 'dart:async';
import 'dart:math';

import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_info.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_software_version.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/dialogs/error_presenter.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/application_layer/car_connection_tracer.dart';
import 'package:rxdart/rxdart.dart';

class CarSoftwareUpdateService {
  CarSoftwareUpdateService({
    required CarCommunication carCommunication,
    required SelectedCarService selectedCarService,
    required CarSoftwareVersionFactory carSoftwareVersionFactory,
    required ErrorPresenter errorPresenter,
    required CarConnectionTracer tracer,
  })  : _carCommunication = carCommunication,
        _selectedCarService = selectedCarService,
        _carSoftwareVersionFactory = carSoftwareVersionFactory,
        _errorPresenter = errorPresenter,
        _tracer = tracer {
    _setupNextSoftwareVersionListener();
  }

  final CarCommunication _carCommunication;
  final SelectedCarService _selectedCarService;
  final CarSoftwareVersionFactory _carSoftwareVersionFactory;
  final ErrorPresenter _errorPresenter;
  final CarConnectionTracer _tracer;

  StreamSubscription? _nextSoftwareVersionSubscription;
  StreamSubscription? _updateProgressSubscription;

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
      await _tracer.startUpdateSoftwareSpan(
        action: (span) async {
          span.addEvent(
            'Starting update! Current version is: ${car.info.softwareVersion}, will update to: $nextVersion',
          );

          _setupUpdateProgressListener();

          await _carCommunication.updateSoftware(nextVersion);
          _updateCar(car: car, newSoftwareVersion: nextVersion);

          span.addEvent(
            'Updated! New version is: $nextVersion',
          );
        },
      );
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
    _nextSoftwareVersionSubscription?.cancel();
    _updateProgressSubscription?.cancel();
  }

  void _setupNextSoftwareVersionListener() {
    _nextSoftwareVersionSubscription?.cancel();
    _nextSoftwareVersionSubscription =
        _selectedCarService.carStream.listen((car) {
      if (car != null) {
        final currentVersion = car.info.softwareVersion;
        final nextVersion = _carSoftwareVersionFactory.getRandomNextVersion(
          currentVersion: currentVersion,
        );
        _newSoftwareVersionSubject.add(nextVersion);
      }
    });
  }

  void _setupUpdateProgressListener() {
    _updateProgressSubscription?.cancel();
    var isFirstProgress = true;
    _updateProgressSubscription =
        _carCommunication.softwareUpdateProgressStream.listen((progress) {
      if (isFirstProgress) {
        isFirstProgress = false;
        return;
      }

      _updateProgressSubject.add(progress);
      final printableProgress = min(progress * 100, 100).toStringAsFixed(2);
      _tracer.addEventToSoftwareUpdateSpan('Progress: $printableProgress%');
    });
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
