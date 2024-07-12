import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/application_layer/providers.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/widgets/phone_to_car/connected_widget.dart';
import 'package:flutter_mobile_o11y_demo/features/car_actions/presentation/widgets/phone_to_car/not_connected_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'phone_to_car_actions_widget.g.dart';

class PhoneToCarActionsWidget extends ConsumerWidget {
  const PhoneToCarActionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = ref.watch(isConnectedToCarProvider);

    if (isConnected) {
      return const ConnectedWidget();
    } else {
      return const NotConnectedWidget();
    }
  }
}

@riverpod
bool isConnectedToCar(
  IsConnectedToCarRef ref,
) {
  final carConnectionService = ref.watch(carConnectionServiceProvider);

  final subscription = carConnectionService.isConnectedChanged.listen((_) {
    ref.invalidateSelf();
  });
  ref.onDispose(subscription.cancel);

  return carConnectionService.isConnected;
}
