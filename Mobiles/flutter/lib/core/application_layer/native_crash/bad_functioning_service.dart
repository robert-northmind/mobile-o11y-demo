import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/loggers/o11y_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final badFunctioningServiceProvider = Provider((ref) {
  return BadFunctioningService(
    o11yLogger: ref.watch(o11yLoggerProvider),
  );
});

class BadFunctioningService {
  BadFunctioningService({
    required O11yLogger o11yLogger,
  }) : _o11yLogger = o11yLogger;

  final O11yLogger _o11yLogger;

  void doSomethingWhichThrowsCustomError() {
    _o11yLogger.warning('Oh no, you triggered a custom error!');
    throw CustomError('Throwing a custom error');
  }

  void doSomethingWhichThrowsException() {
    _o11yLogger.warning('Oh no, you triggered an exception!');
    throw Exception('Throwing an exception');
  }

  void doSomethingWhichThrowsSneakyError() {
    _o11yLogger.warning('Oh no, some sneaky error has crawled in!');
    throw CustomError('Oh no, some sneaky error has crawled in!');
  }
}

class CustomError extends Error {
  CustomError(this.message);

  final String message;

  @override
  String toString() {
    return 'CustomError: $message';
  }
}
