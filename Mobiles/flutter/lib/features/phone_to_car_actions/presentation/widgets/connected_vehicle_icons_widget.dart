import 'package:flutter/material.dart';

class ConnectedVehicleIconsWidget extends StatelessWidget {
  const ConnectedVehicleIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi,
          size: 40,
        ),
        Icon(
          Icons.directions_car,
          size: 70,
        ),
      ],
    );
  }
}
