import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/widgets/car_lock_unlock_action_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/presentation/ui_states/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneToCarLockUnlockActionWidget extends ConsumerWidget {
  const PhoneToCarLockUnlockActionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(phoneToCarLockUnlockActionUiStateProvider);
    return CarLockUnlockActionWidget(
      isLoading: uiState.isLoading,
      isLocked: uiState.isLocked,
      onPressed: () {
        final doorActionService = ref.read(carDoorActionServiceProvider);
        if (uiState.isLocked) {
          doorActionService.unlockCar();
        } else {
          doorActionService.lockCar();
        }
      },
    );
  }
}
