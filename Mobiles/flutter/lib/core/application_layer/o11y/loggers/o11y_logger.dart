import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/logger_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final o11yLoggerProvider = Provider((ref) {
  return O11yLogger(clients: [
    ref.watch(consoleLoggerClientProvider),
    ref.watch(faroLoggerClientProvider),
  ]);
});

class O11yLogger {
  O11yLogger({
    required List<LoggerClient> clients,
  }) : _clients = clients;

  final List<LoggerClient> _clients;

  void debug(String message, {Map<String, String> context = const {}}) {
    for (final client in _clients) {
      client.debug(message, context: context);
    }
  }

  void warning(String message, {Map<String, String> context = const {}}) {
    for (final client in _clients) {
      client.warning(message, context: context);
    }
  }

  void error(
    String message, {
    DateTime? time,
    Object? error,
    StackTrace? stackTrace,
    Map<String, String> context = const {},
  }) {
    for (final client in _clients) {
      client.error(
        message,
        error: error,
        stackTrace: stackTrace,
        context: context,
      );
    }
  }
}
