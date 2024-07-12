import 'package:flutter_mobile_o11y_demo/features/car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_actions/connected_to_car_action.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_actions/not_connected_to_car_action.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
NotConnectedToCarUiAction notConnectedToCarUiAction(
  NotConnectedToCarUiActionRef ref,
) {
  return NotConnectedToCarUiAction(
    carConnectionService: ref.watch(carConnectionServiceProvider),
  );
}

@riverpod
ConnectedToCarUiAction connectedToCarUiAction(
  ConnectedToCarUiActionRef ref,
) {
  return ConnectedToCarUiAction(
    carConnectionService: ref.watch(carConnectionServiceProvider),
  );
}
