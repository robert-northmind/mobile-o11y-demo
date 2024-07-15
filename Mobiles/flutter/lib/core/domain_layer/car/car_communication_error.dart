import 'package:flutter_mobile_o11y_demo/core/utils/random_element.dart';

abstract class CarCommunicationError extends Error {
  static CarCommunicationError randomError() {
    final errors = [
      TimeOutError(),
      RandomEcuError(),
      MysticMagicError(),
    ];
    return errors.getRandomElement();
  }
}

class TimeOutError extends CarCommunicationError {
  @override
  String toString() => 'Communication Timeout';
}

class RandomEcuError extends CarCommunicationError {
  @override
  String toString() => 'Random ECU Error';
}

class MysticMagicError extends CarCommunicationError {
  @override
  String toString() => 'Mystic Magic Error';
}

class NotConnectedError extends CarCommunicationError {
  @override
  String toString() => 'Not Connected Error';
}
