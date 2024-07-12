import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation/widgets/button_with_loading.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_actions/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/widgets/phone_to_car_connection_info_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConnectedWidget extends ConsumerWidget {
  const ConnectedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(connectedToCarUiStateProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            PhoneToCarConnectionInfoWidget(),
            const Divider(),
            const Icon(
              Icons.directions_car,
              size: 70,
            ),
            ButtonWithLoading(
              title: 'Disconnect',
              isLoading: uiState.isLoading,
              onPressed: () {
                ref.read(connectedToCarUiActionProvider).disconnectFromCar();
              },
            ),
            const Divider(),
            PhoneToCarLockUnlockActionWidget(),
            const Divider(),
            PhoneToCarUpdateSoftwareActionWidget(),
          ],
        ),
      ),
    );
  }
}

class PhoneToCarLockUnlockActionWidget extends StatelessWidget {
  const PhoneToCarLockUnlockActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Lock / Unlock'),
      ],
    );
  }
}

class PhoneToCarUpdateSoftwareActionWidget extends StatelessWidget {
  const PhoneToCarUpdateSoftwareActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Update software'),
      ],
    );
  }
}
