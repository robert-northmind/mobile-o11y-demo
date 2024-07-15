import 'package:flutter_mobile_o11y_demo/core/domain_layer/car/car_software_version.dart';

abstract class CarCommunication {
  Stream<bool> get isConnectedStream;
  bool get isConnected;

  Stream<double> get softwareUpdateProgressStream;

  Future<void> connectToCar();
  Future<void> disconnectFromCar();

  Future<void> lockDoors();
  Future<void> unlockDoors();

  Future<void> updateSoftware(CarSoftwareVersion nextVersion);

  void dispose();
}
