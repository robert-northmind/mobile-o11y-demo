// ignore_for_file: cascade_invocations

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

class PhoneToCarUpdateSoftwareActionUiState extends Equatable {
  const PhoneToCarUpdateSoftwareActionUiState({
    required this.currentVersionNumber,
    required this.newVersionNumber,
    required this.isUpdatingSoftware,
    required this.updateProgress,
  });

  final String currentVersionNumber;
  final String newVersionNumber;
  final bool isUpdatingSoftware;
  final double updateProgress;

  @override
  List<Object?> get props => [
        currentVersionNumber,
        newVersionNumber,
        isUpdatingSoftware,
        updateProgress
      ];
}

final phoneToCarUpdateSoftwareActionUiStateProvider =
    AutoDisposeProvider((ref) {
  final car = ref.watch(getConnectedCarProvider);
  final updateService = ref.watch(carSoftwareUpdateServiceProvider);

  final subscriptions = <StreamSubscription>[];
  subscriptions.add(
    updateService.updateProgressStream.skip(1).listen((_) {
      ref.invalidateSelf();
    }),
  );
  subscriptions.add(
    updateService.inProgressStream.skip(1).listen((_) {
      ref.invalidateSelf();
    }),
  );
  subscriptions.add(
    updateService.newSoftwareVersionStream.skip(1).listen((_) {
      ref.invalidateSelf();
    }),
  );

  ref.onDispose(() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
  });

  return PhoneToCarUpdateSoftwareActionUiState(
    currentVersionNumber: car?.info.softwareVersion.toString() ?? '',
    newVersionNumber: updateService.newSoftwareVersion.toString(),
    isUpdatingSoftware: updateService.inProgress,
    updateProgress: updateService.updateProgress,
  );
});
