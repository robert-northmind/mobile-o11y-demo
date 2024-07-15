import 'package:flutter/material.dart';

class LockUnlockCarStatusWidget extends StatelessWidget {
  const LockUnlockCarStatusWidget({
    super.key,
    required this.isLocked,
  });

  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          isLocked ? Icons.lock : Icons.lock_open,
          size: 40,
        ),
        const Icon(
          Icons.directions_car,
          size: 70,
        ),
      ],
    );
  }
}
