import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/faro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rum_sdk/rum_sdk.dart';

final carConnectionTracerProvider = Provider((ref) {
  return CarConnectionTracer(
    tracer: ref.watch(tracerProvider),
  );
});

class CarConnectionTracer {
  CarConnectionTracer({
    required Tracer tracer,
  }) : _tracer = tracer;

  final Tracer _tracer;

  Span? _connectedSpan;
  Span? _lockUnlockDoorsSpan;
  Span? _updateSoftwareSpan;

  SpanStatusCode? _lastFailedStatus;

  void connectedToCar() {
    _lastFailedStatus = null;
    _connectedSpan =
        _tracer.startSpan('Phone2Car-ConnectedToCar', isActive: true);

    // TODO: Add this!
    // applySpanAttributes()
  }

  void disconnectedFromCar() {
    if (_lastFailedStatus != null) {
      _connectedSpan?.setStatus(_lastFailedStatus!);
    } else {
      _connectedSpan?.setStatus(SpanStatusCode.ok);
    }
    _connectedSpan?.end();
    _connectedSpan = null;
    _lastFailedStatus = null;
  }

  void startLockUnlockDoorsSpan({required bool shouldLock}) {
    if (shouldLock) {
      _lockUnlockDoorsSpan = _tracer.startSpan(
        'Phone2Car-LockDoors',
        parentSpan: _connectedSpan,
      );
    } else {
      _lockUnlockDoorsSpan = _tracer.startSpan(
        'Phone2Car-UnlockDoors',
        parentSpan: _connectedSpan,
      );
    }
  }

  void endLockUnlockDoorSpan({
    required bool shouldLock,
    required SpanStatusCode status,
    String? message,
  }) {
    if (status == SpanStatusCode.error) {
      _lastFailedStatus = status;
    }

    _lockUnlockDoorsSpan?.setStatus(status, message: message);
    _lockUnlockDoorsSpan?.end();
    _lockUnlockDoorsSpan = null;
  }

  void startUpdateSoftwareSpan() {
    _updateSoftwareSpan = _tracer.startSpan(
      'Phone2Car-UpdateSoftware',
      parentSpan: _connectedSpan,
    );
  }

  void addEventToSoftwareUpdateSpan(String event) {
    _updateSoftwareSpan?.addEvent(event);
  }

  void endUpdateSoftwareSpan({
    required SpanStatusCode status,
    String? message,
  }) {
    if (status == SpanStatusCode.error) {
      _lastFailedStatus = status;
    }

    _updateSoftwareSpan?.setStatus(status, message: message);
    _updateSoftwareSpan?.end();
    _updateSoftwareSpan = null;
  }
}
