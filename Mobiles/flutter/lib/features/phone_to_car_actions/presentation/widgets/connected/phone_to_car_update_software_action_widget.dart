// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation/widgets/button_with_progress.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/phone_to_car_update_software_action_ui_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneToCarUpdateSoftwareActionWidget extends ConsumerWidget {
  const PhoneToCarUpdateSoftwareActionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(phoneToCarUpdateSoftwareActionUiStateProvider);

    return Column(
      children: [
        const Text(
          'A new software version is available for your car. You can update your car from your phone.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text('Current version: ${uiState.currentVersionNumber}'),
        Text('New version: ${uiState.newVersionNumber}'),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.send_to_mobile, size: 40),
            Icon(Icons.description),
            Icon(Icons.directions_car, size: 50),
          ],
        ),
        ButtonWithProgress(
          title: 'Update Car Software',
          isInProgress: uiState.isUpdatingSoftware,
          currentProgress: uiState.updateProgress,
          onPressed: () {
            ref.read(carSoftwareUpdateServiceProvider).updateSoftware();
          },
        ),
      ],
    );
  }
}
