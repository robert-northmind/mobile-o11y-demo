/// Represents the type of error simulation to apply for remote car actions.
/// This is used for testing and observability purposes.
enum ErrorSimulationType {
  /// No error - normal operation
  none,

  /// Simulate a 400 Bad Request error
  badRequest,

  /// Simulate a 500 Internal Server Error
  internalServerError,

  /// Random error (15% probability) - default behavior
  random,
}

extension ErrorSimulationTypeX on ErrorSimulationType {
  /// Converts the enum to the header value format
  String toHeaderValue() {
    switch (this) {
      case ErrorSimulationType.none:
        return 'none';
      case ErrorSimulationType.badRequest:
        return '400';
      case ErrorSimulationType.internalServerError:
        return '500';
      case ErrorSimulationType.random:
        return 'random';
    }
  }

  /// User-friendly display name for the UI
  String get displayName {
    switch (this) {
      case ErrorSimulationType.none:
        return 'No Error';
      case ErrorSimulationType.badRequest:
        return 'Bad Request (400)';
      case ErrorSimulationType.internalServerError:
        return 'Internal Server Error (500)';
      case ErrorSimulationType.random:
        return 'Random (15%)';
    }
  }
}
