// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/selected_car/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/application_layer/remote_car_action_service.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/domain/error_simulation_type.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteActionsPageUiState extends Equatable {
  const RemoteActionsPageUiState({
    required this.isLoading,
    required this.isLocked,
    required this.errorSimulationType,
  });

  final bool isLoading;
  final bool isLocked;
  final ErrorSimulationType errorSimulationType;

  @override
  List<Object?> get props => [isLoading, isLocked, errorSimulationType];
}

final remoteActionsPageUiStateProvider = Provider((ref) {
  final selectedCarService = ref.watch(selectedCarServiceProvider);
  final remoteCarActionService = ref.watch(remoteCarActionServiceProvider);

  final subscriptions = <StreamSubscription>[];
  subscriptions.add(
    selectedCarService.carStream.skip(1).listen((_) {
      ref.invalidateSelf();
    }),
  );
  subscriptions.add(
    remoteCarActionService.isLoadingStream.skip(1).listen((_) {
      ref.invalidateSelf();
    }),
  );
  subscriptions.add(
    remoteCarActionService.errorSimulationTypeStream.skip(1).listen((_) {
      ref.invalidateSelf();
    }),
  );

  ref.onDispose(() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  });

  final car = selectedCarService.car;
  final isLocked = car?.doorStatus.isLocked ?? false;
  final isLoading = remoteCarActionService.isLoading;
  final errorSimulationType = remoteCarActionService.errorSimulationType;

  return RemoteActionsPageUiState(
    isLoading: isLoading,
    isLocked: isLocked,
    errorSimulationType: errorSimulationType,
  );
});
