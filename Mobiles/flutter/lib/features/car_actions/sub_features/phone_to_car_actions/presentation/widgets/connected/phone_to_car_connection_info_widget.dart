import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/sub_features/phone_to_car_actions/presentation/ui_states/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PhoneToCarConnectionInfoWidget extends ConsumerWidget {
  const PhoneToCarConnectionInfoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(phoneToCarConnectionInfoUiStateProvider);
    return Column(
      children: [
        Text('Connected to: ${uiState.connectedToName}'),
        Text('VIN: ${uiState.connectedToVin}'),
      ],
    );
  }
}
