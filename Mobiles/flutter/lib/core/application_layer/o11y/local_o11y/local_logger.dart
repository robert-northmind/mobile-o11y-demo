import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/logger_client.dart';

class LocalLoggerClient implements LoggerClient {
  @override
  void debug(String message, {required Map<String, String> context}) {
    print('LocalLoggerClient: debug: $message, $context');
  }

  @override
  void error(String message,
      {Object? error,
      StackTrace? stackTrace,
      required Map<String, String> context}) {
    print('LocalLoggerClient: error: $message, $error, $stackTrace, $context');
  }

  @override
  void warning(String message, {required Map<String, String> context}) {
    print('LocalLoggerClient: warning: $message, $context');
  }
}
