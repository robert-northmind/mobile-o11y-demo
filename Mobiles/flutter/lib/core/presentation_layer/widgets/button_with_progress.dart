import 'package:flutter/material.dart';

class ButtonWithProgress extends StatelessWidget {
  const ButtonWithProgress({
    super.key,
    required this.title,
    required this.isInProgress,
    required this.currentProgress,
    required this.onPressed,
    this.width = 270,
  });

  final String title;
  final bool isInProgress;
  final double currentProgress;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: width,
          child: ElevatedButton(
            onPressed: isInProgress ? null : onPressed,
            child: Text(title),
          ),
        ),
        if (isInProgress)
          Padding(
            padding: const EdgeInsets.all(16),
            child: LinearProgressIndicator(
              value: currentProgress,
            ),
          ),
      ],
    );
  }
}
