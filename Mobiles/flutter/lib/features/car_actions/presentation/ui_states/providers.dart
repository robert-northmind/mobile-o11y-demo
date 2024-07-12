import 'package:flutter_mobile_o11y_demo/features/car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_states/connected_to_car_ui_state.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_states/not_connected_to_car_ui_state.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_states/phone_to_car_actions_ui_state.dart';
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
