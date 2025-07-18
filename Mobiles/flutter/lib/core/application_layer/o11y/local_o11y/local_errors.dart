import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/errors/o11y_errors.dart';

class LocalO11yErrors implements O11yErrors {
  @override
  void reportError({
    required String type,
    required String error,
    StackTrace? stacktrace,
    Map<String, String>? context,
  }) {
    print('LocalO11yErrors: reportError: $type, $error, $stacktrace, $context');
  }
}
