import 'package:flutter/material.dart';

class ConnectedVehicleIconsWidget extends StatelessWidget {
  const ConnectedVehicleIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.sensors,
          size: 50,
        ),
      ],
    );
  }
}
