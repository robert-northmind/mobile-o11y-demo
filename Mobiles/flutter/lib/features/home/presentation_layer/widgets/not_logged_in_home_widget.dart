import 'package:flutter/material.dart';

class NotLoggedInHomeWidget extends StatelessWidget {
  const NotLoggedInHomeWidget({super.key});

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileO11y Demo'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hi and welcome back'),
          ],
        ),
      ),
    );
  }
}
