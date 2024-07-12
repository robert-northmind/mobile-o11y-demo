import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car.dart';
import 'package:rxdart/rxdart.dart';

class CarConnectionService {
  CarConnectionService({
    required CarFactory carFactory,
  }) : _carFactory = carFactory;

  final CarFactory _carFactory;
  final _carSubject = BehaviorSubject<Car?>.seeded(null);
  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  bool get isLoading => _isLoadingSubject.value;

  Stream<void> get isConnectedChanged =>
      _carSubject.stream.map((car) => car != null);
  bool get isConnected => _carSubject.value != null;

  Stream<Car?> get carStream => _carSubject.stream;

  void dispose() {
    _isLoadingSubject.close();
    _carSubject.close();
  }

  Future<void> connectToCar() async {
    _isLoadingSubject.add(true);
    await Future.delayed(const Duration(seconds: 1));

    final car = _carFactory.getRandomCar();
    _carSubject.add(car);
    _isLoadingSubject.add(false);
  }

  Future<void> disconnectFromCar() async {
    _isLoadingSubject.add(true);
    await Future.delayed(const Duration(seconds: 1));

    _carSubject.add(null);
    _isLoadingSubject.add(false);
  }
}
