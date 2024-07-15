import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/widgets/button_with_loading.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotConnectedWidget extends ConsumerWidget {
  const NotConnectedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(notConnectedToCarUiStateProvider);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              // ignore: lines_longer_than_80_chars
              'You are not yet connected to your car. If you are next to your car you can connect your phone to it and control it directly from your phone.',
              textAlign: TextAlign.center,
            ),
            const Divider(),
            const Icon(
              Icons.sensors_off,
              size: 50,
            ),
            ButtonWithLoading(
              title: 'Connect phone directly to car',
              isLoading: uiState.isLoading,
              onPressed: () {
                ref.read(carConnectionServiceProvider).connectToCar();
              },
            ),
          ],
        ),
      ),
    );
  }
}
