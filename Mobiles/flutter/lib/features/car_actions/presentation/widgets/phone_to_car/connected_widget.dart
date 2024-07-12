import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation/widgets/button_with_loading.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_actions/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_states/providers.dart';
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
            const Text(
              'You are connected to your car.',
              textAlign: TextAlign.center,
            ),
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
          ],
        ),
      ),
    );
  }
}
