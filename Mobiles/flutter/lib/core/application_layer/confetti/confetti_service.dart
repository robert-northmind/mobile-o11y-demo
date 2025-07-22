// ignore_for_file: cascade_invocations

import 'package:confetti/confetti.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/native_crash/bad_functioning_service.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final confettiServiceProvider = Provider.autoDispose<ConfettiService>((ref) {
  final service = ConfettiService(
    logger: ref.watch(o11yLoggerProvider),
    badFunctioningService: ref.watch(badFunctioningServiceProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

class ConfettiService {
  ConfettiService({
    required O11yLogger logger,
    required BadFunctioningService badFunctioningService,
  })  : _logger = logger,
        _badFunctioningService = badFunctioningService;

  final O11yLogger _logger;
  final Map<String, ConfettiController> _controllers = {};
  final BadFunctioningService _badFunctioningService;

  /// Creates or gets an existing confetti controller for the given key
  ConfettiController getController(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] =
          ConfettiController(duration: const Duration(seconds: 2));
      _logger.debug('Created new confetti controller',
          context: {'controller_key': key});
    }
    return _controllers[key]!;
  }

  /// Triggers confetti explosion for the given controller key
  void explode(String key) {
    _badFunctioningService.doSomethingWhichThrowsSneakyError();
    final controller = getController(key);
    controller.play();
    _logger.debug('Confetti explosion triggered',
        context: {'controller_key': key});
  }

  /// Stops confetti for the given controller key
  void stop(String key) {
    if (_controllers.containsKey(key)) {
      _controllers[key]!.stop();
      _logger.debug('Confetti stopped', context: {'controller_key': key});
    }
  }

  /// Disposes all controllers and cleans up resources
  void dispose() {
    for (final entry in _controllers.entries) {
      entry.value.dispose();
      _logger.debug('Disposed confetti controller',
          context: {'controller_key': entry.key});
    }
    _controllers.clear();
  }
}
