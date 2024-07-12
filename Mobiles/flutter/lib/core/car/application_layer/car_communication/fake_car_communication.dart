import 'dart:math';

import 'package:flutter_mobile_o11y_demo/core/car/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_communication_error.dart';
import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_software_version.dart';
import 'package:rxdart/rxdart.dart';

class FakeCarCommunication implements CarCommunication {
  final _isConnectedSubject = BehaviorSubject<bool>.seeded(false);
  final _softwareUpdateProgressSubject = BehaviorSubject<double>.seeded(0);

  @override
  Stream<bool> get isConnectedStream => _isConnectedSubject.stream;

  @override
  bool get isConnected => _isConnectedSubject.value;

  @override
  Stream<double> get softwareUpdateProgressStream =>
      _softwareUpdateProgressSubject.stream;

  @override
  Future<void> connectToCar() async {
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    _isConnectedSubject.value = true;
  }

  @override
  Future<void> disconnectFromCar() async {
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    _isConnectedSubject.value = false;
  }

  @override
  Future<void> lockDoors() async {
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    await _throwFakeError(probabilityInPercent: 10);
  }

  @override
  Future<void> unlockDoors() async {
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    await _throwFakeError(probabilityInPercent: 10);
  }

  @override
  Future<void> updateSoftware(CarSoftwareVersion nextVersion) async {
    _softwareUpdateProgressSubject.value = 0;

    while (_softwareUpdateProgressSubject.value < 100) {
      await _makeFakeConnectionDelay(minSec: 1, maxSec: 2.5);
      await _throwFakeError(probabilityInPercent: 6);
      _softwareUpdateProgressSubject.value = min(
        _softwareUpdateProgressSubject.value + 10,
        100,
      );
    }
    await _makeFakeConnectionDelay(minSec: 1, maxSec: 2.5);
  }

  @override
  void dispose() {
    _isConnectedSubject.close();
    _softwareUpdateProgressSubject.close();
  }

  Future<void> _throwFakeError({
    required int probabilityInPercent,
  }) async {
    final safeProbability = max(min(probabilityInPercent, 100), 0);
    final randomValue = Random().nextInt(100);
    if (randomValue < safeProbability) {
      throw CarCommunicationError.randomError();
    }
  }

  Future<void> _makeFakeConnectionDelay({
    required double minSec,
    required double maxSec,
  }) async {
    final seconds = Random().nextDouble() * (maxSec - minSec) + minSec;
    await Future.delayed(
      Duration(milliseconds: (seconds * 1000).toInt()),
    );
  }
}
