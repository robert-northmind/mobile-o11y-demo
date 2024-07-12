import 'package:flutter/material.dart';

class ButtonWithLoading extends StatelessWidget {
  const ButtonWithLoading({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onPressed,
    this.width = 240,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(title),
      ),
    );
  }
}
