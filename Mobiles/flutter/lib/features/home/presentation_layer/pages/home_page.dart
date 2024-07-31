import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileO11y Demo'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Hi and welcome back',
              textAlign: TextAlign.center,
            ),
            Text(
              'Some Random name',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'This is your car',
              textAlign: TextAlign.center,
            ),
            Text(
              'Some car info',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
