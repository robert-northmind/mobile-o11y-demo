// ignore_for_file: use_setters_to_change_properties

import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car.dart';
import 'package:rxdart/rxdart.dart';

class SelectedCarService {
  SelectedCarService({
    required CarFactory carFactory,
  }) {
    _carSubject.value = carFactory.getRandomCar();
  }

  final _carSubject = BehaviorSubject<Car?>.seeded(null);

  Stream<Car?> get carStream => _carSubject.stream;
  Car? get car => _carSubject.value;

  void dispose() {
    _carSubject.close();
  }

  void updateSelectedCar(Car car) {
    _carSubject.value = car;
  }
}
