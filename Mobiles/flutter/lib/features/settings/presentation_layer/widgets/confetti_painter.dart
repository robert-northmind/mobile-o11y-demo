// ignore_for_file: avoid_redundant_argument_values

import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/confetti/confetti_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfettiPainter extends ConsumerWidget {
  const ConfettiPainter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final confettiService = ref.watch(confettiServiceProvider);
    final confettiController =
        confettiService.getController('settings_page_confetti');
    return ConfettiWidget(
      confettiController: confettiController,
      blastDirection: -pi / 2, // Blast upward
      blastDirectionality:
          BlastDirectionality.explosive, // Spread in all directions
      particleDrag: 0.05,
      emissionFrequency: 0.05,
      numberOfParticles: 30,
      gravity: 0.3,
      maxBlastForce: 25,
      minBlastForce: 15,
      colors: const [
        Colors.green,
        Colors.blue,
        Colors.pink,
        Colors.orange,
        Colors.purple,
        Colors.yellow,
        Colors.red,
      ],
    );
  }
}
