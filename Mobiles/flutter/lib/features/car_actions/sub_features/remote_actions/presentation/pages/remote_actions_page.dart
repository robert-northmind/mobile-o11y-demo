import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/widgets/car_lock_unlock_action_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/application_layer/remote_car_action_service.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/remote_actions/presentation/ui_states/remote_actions_page_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RemoteActionsPage extends ConsumerWidget {
  const RemoteActionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(remoteActionsPageUiStateProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Here you can control your car from anywhere in the world!',
              textAlign: TextAlign.center,
            ),
            const Divider(),
            CarLockUnlockActionWidget(
              isLoading: uiState.isLoading,
              isLocked: uiState.isLocked,
              onPressed: () {
                if (uiState.isLocked) {
                  ref.read(remoteCarActionServiceProvider).unlockDoors();
                } else {
                  ref.read(remoteCarActionServiceProvider).lockDoors();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
