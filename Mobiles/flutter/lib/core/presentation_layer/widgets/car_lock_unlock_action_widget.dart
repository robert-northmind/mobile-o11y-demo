import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/widgets/button_with_loading.dart';
import 'package:flutter_mobile_o11y_demo/core/presentation_layer/widgets/lock_unlock_car_status_widget.dart';

class CarLockUnlockActionWidget extends StatelessWidget {
  const CarLockUnlockActionWidget({
    super.key,
    required this.isLocked,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLocked;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LockUnlockCarStatusWidget(isLocked: isLocked),
        ButtonWithLoading(
          title: isLocked ? 'Unlock' : 'Lock',
          isLoading: isLoading,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
