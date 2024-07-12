enum CarCommunicationError {
  timeout,
  randomEcuError,
  mysticMagicError,
}

extension CarCommunicationErrorX on CarCommunicationError {
  String get description {
    switch (this) {
      case CarCommunicationError.timeout:
        return 'Communication Timeout';
      case CarCommunicationError.randomEcuError:
        return 'Random ECU Error';
      case CarCommunicationError.mysticMagicError:
        return 'Mystic Magic Error';
    }
  }
}
