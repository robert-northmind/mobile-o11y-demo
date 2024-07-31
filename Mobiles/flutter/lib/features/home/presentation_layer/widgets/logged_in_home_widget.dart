import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/features/home/presentation_layer/pages/home_page.dart';

class LoggedInHomeWidget extends StatelessWidget {
  const LoggedInHomeWidget({super.key, required this.homeUiState});

  final LoggedInHomeUiState homeUiState;

  @override
  Widget build(Object context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MobileO11y Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hi and welcome back',
              textAlign: TextAlign.center,
            ),
            Text(
              homeUiState.username,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Text(
              homeUiState.carInfo,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Image.asset(homeUiState.carImagePath, fit: BoxFit.contain),
            ),
          ],
        ),
      ),
    );
  }
}
