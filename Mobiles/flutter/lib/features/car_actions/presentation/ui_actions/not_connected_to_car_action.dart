import 'package:flutter_mobile_o11y_demo/features/car_actions/application_layer/car_connection_service.dart';

class NotConnectedToCarUiAction {
  NotConnectedToCarUiAction({
    required CarConnectionService carConnectionService,
  }) : _carConnectionService = carConnectionService;

  final CarConnectionService _carConnectionService;

  void connectToCar() {
    _carConnectionService.connectToCar();
  }
}
