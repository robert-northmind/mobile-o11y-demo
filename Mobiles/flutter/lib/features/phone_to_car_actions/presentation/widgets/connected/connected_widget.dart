import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation/widgets/button_with_loading.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/ui_states/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/widgets/connected/connected_vehicle_icons_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/widgets/connected/phone_to_car_connection_info_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/widgets/connected/phone_to_car_lock_unlock_action_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/phone_to_car_actions/presentation/widgets/connected/phone_to_car_update_software_action_widget.dart';
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
            const PhoneToCarConnectionInfoWidget(),
            const Divider(),
            const ConnectedVehicleIconsWidget(),
            ButtonWithLoading(
              title: 'Disconnect',
              isLoading: uiState.isLoading,
              onPressed: () {
                ref.read(carConnectionServiceProvider).disconnectFromCar();
              },
            ),
            const Divider(),
            const PhoneToCarLockUnlockActionWidget(),
            const Divider(),
            const PhoneToCarUpdateSoftwareActionWidget(),
          ],
        ),
      ),
    );
  }
}
