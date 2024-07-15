import 'package:flutter_mobile_o11y_demo/core/application_layer/car_communication/car_communication.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/selected_car_service.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car.dart';
import 'package:rxdart/rxdart.dart';

class CarConnectionService {
  CarConnectionService({
    required CarCommunication carCommunication,
    required SelectedCarService selectedCarService,
  })  : _carCommunication = carCommunication,
        _selectedCarService = selectedCarService;

  final CarCommunication _carCommunication;
  final SelectedCarService _selectedCarService;

  final _isLoadingSubject = BehaviorSubject<bool>.seeded(false);

  Stream<bool> get isLoadingStream => _isLoadingSubject.stream;
  bool get isLoading => _isLoadingSubject.value;

  Stream<void> get isConnectedChanged =>
      _carCommunication.isConnectedStream.map((_) {});
  bool get isConnected => _carCommunication.isConnected;

  Stream<Car?> get carStream => _selectedCarService.carStream;
  Car? get car => _selectedCarService.car;

  Future<void> connectToCar() async {
    _isLoadingSubject.add(true);
    await _carCommunication.connectToCar();
    _isLoadingSubject.add(false);
  }

  Future<void> disconnectFromCar() async {
    _isLoadingSubject.add(true);
    await _carCommunication.disconnectFromCar();
    _isLoadingSubject.add(false);
  }

  void dispose() {
    _isLoadingSubject.close();
  }
}
