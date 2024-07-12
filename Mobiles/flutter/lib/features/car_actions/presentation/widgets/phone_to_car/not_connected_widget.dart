import 'package:flutter/material.dart';

class NotConnectedWidget extends StatelessWidget {
  const NotConnectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
              Icons.directions_car,
              size: 70,
            ),
            ElevatedButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: const Text('Connect phone directly to car'),
            ),
          ],
        ),
      ),
    );
  }
}
