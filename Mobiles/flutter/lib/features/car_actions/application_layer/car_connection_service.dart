import 'dart:async';

import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car.dart';
import 'package:rxdart/rxdart.dart';

class CarConnectionService {
  CarConnectionService({
    required CarFactory carFactory,
  }) : _carFactory = carFactory {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_carSubject.value == null) {
        final car = _carFactory.getRandomCar();
        _carSubject.add(car);
      } else {
        _carSubject.add(null);
      }
    });
  }

  late final Timer? _timer;
  final CarFactory _carFactory;
  final _carSubject = BehaviorSubject<Car?>.seeded(null);

  Stream<bool> get isLoading => const Stream.empty();

  Stream<void> get isConnectedChanged =>
      _carSubject.stream.map((car) => car != null);
  bool get isConnected => _carSubject.value != null;

  Stream<Car?> get carStream => _carSubject.stream;

  void dispose() {
    _timer?.cancel();
    _carSubject.close();
  }

  Future<void> connectToCar() async {}

  Future<void> disconnectFromCar() async {}
}
