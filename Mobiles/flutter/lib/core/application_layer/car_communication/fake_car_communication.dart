import 'dart:math';

import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_communication_error.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_software_version.dart';
import 'package:rxdart/rxdart.dart';

class FakeCarCommunication implements CarCommunication {
  FakeCarCommunication({
    required O11yLogger logger,
  }) : _logger = logger;

  final O11yLogger _logger;
  final _loggerContext = {'service': 'FakeCarCommunication'};

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
    _logger.debug('Connecting to car', context: _loggerContext);
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    _isConnectedSubject.value = true;
  }

  @override
  Future<void> disconnectFromCar() async {
    _logger.debug('Disconnecting to car', context: _loggerContext);
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    _isConnectedSubject.value = false;
  }

  @override
  Future<void> lockDoors() async {
    _logger.debug('Locking to car', context: _loggerContext);
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    await _throwFakeError(probabilityInPercent: 10);
  }

  @override
  Future<void> unlockDoors() async {
    _logger.debug('Unlocking to car', context: _loggerContext);
    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 1.5);
    await _throwFakeError(probabilityInPercent: 10);
  }

  @override
  Future<void> updateSoftware(CarSoftwareVersion nextVersion) async {
    _logger.debug('Updating software', context: {
      ..._loggerContext,
      'nextVersion': nextVersion.toString(),
    });
    _softwareUpdateProgressSubject.value = 0;

    while (_softwareUpdateProgressSubject.value < 1) {
      _checkIfConnectedAndCanStillUpdate();
      await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 2.1);
      await _throwFakeError(probabilityInPercent: 6);
      _softwareUpdateProgressSubject.value = min(
        _softwareUpdateProgressSubject.value + 0.1,
        100,
      );
    }

    _logger.debug('Updating software got progress', context: {
      ..._loggerContext,
      'nextVersion': nextVersion.toString(),
      'progress': _softwareUpdateProgressSubject.value.toString(),
    });

    await _makeFakeConnectionDelay(minSec: 0.5, maxSec: 2.1);
  }

  @override
  void dispose() {
    _isConnectedSubject.close();
    _softwareUpdateProgressSubject.close();
  }

  void _checkIfConnectedAndCanStillUpdate() {
    if (!isConnected) {
      _logger.error(
        'Not connected to car anymore',
        context: _loggerContext,
      );
      throw NotConnectedError();
    }
  }

  Future<void> _throwFakeError({
    required int probabilityInPercent,
  }) async {
    final safeProbability = max(min(probabilityInPercent, 100), 0);
    final randomValue = Random().nextInt(100);
    if (randomValue < safeProbability) {
      final fakeException = CarCommunicationError.randomError();
      _logger.warning(
        'Throwing fake error',
        context: {
          ..._loggerContext,
          'fakeErrorType': fakeException.toString(),
        },
      );
      throw fakeException;
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
