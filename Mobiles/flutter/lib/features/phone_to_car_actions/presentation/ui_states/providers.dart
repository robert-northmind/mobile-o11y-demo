import 'package:flutter_mobile_o11y_demo/core/car/domain_layer/car_model.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/connected_to_car_ui_state.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/not_connected_to_car_ui_state.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/phone_to_car_actions_ui_state.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/phone_to_car_connection_info_ui_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'providers.g.dart';

@riverpod
PhoneToCarActionsUiState phoneToCarActionsUiState(
  PhoneToCarActionsUiStateRef ref,
) {
  final carConnectionService = ref.watch(carConnectionServiceProvider);
  final subscription =
      carConnectionService.isConnectedChanged.skip(1).listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  return PhoneToCarActionsUiState(
    isConnected: carConnectionService.isConnected,
  );
}

@riverpod
ConnectedToCarUiState connectedToCarUiState(
  ConnectedToCarUiStateRef ref,
) {
  final isLoading = ref.watch(_isLoadingCarConnectionStateProvider);
  return ConnectedToCarUiState(
    isLoading: isLoading,
  );
}

@riverpod
NotConnectedToCarUiState notConnectedToCarUiState(
  NotConnectedToCarUiStateRef ref,
) {
  final isLoading = ref.watch(_isLoadingCarConnectionStateProvider);
  return NotConnectedToCarUiState(
    isLoading: isLoading,
  );
}

@riverpod
PhoneToCarConnectionInfoUiState phoneToCarConnectionInfoUiState(
  PhoneToCarConnectionInfoUiStateRef ref,
) {
  final carConnectionService = ref.watch(carConnectionServiceProvider);
  final subscription = carConnectionService.carStream.skip(1).listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  final car = carConnectionService.car;

  return PhoneToCarConnectionInfoUiState(
    connectedToName: car?.info.model.description ?? '',
    connectedToVin: car?.info.vin ?? '',
  );
}

@riverpod
bool _isLoadingCarConnectionState(
  _IsLoadingCarConnectionStateRef ref,
) {
  final carConnectionService = ref.watch(carConnectionServiceProvider);
  final subscription = carConnectionService.isLoadingStream.skip(1).listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);
  return carConnectionService.isLoading;
}
