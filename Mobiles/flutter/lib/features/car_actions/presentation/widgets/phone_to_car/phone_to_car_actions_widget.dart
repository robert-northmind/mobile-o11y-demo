import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/ui_states/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/widgets/phone_to_car/connected_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/widgets/phone_to_car/not_connected_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneToCarActionsWidget extends ConsumerWidget {
  const PhoneToCarActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(phoneToCarActionsUiStateProvider);

    if (uiState.isConnected) {
      return const ConnectedWidget();
    } else {
      return const NotConnectedWidget();
    }
  }
}
