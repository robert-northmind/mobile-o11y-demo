import 'package:flutter/material.dart';

class ConnectedWidget extends StatelessWidget {
  const ConnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: const Text('Disconnect'),
            ),
          ],
        ),
      ),
    );
  }
}
