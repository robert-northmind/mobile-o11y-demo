import 'dart:async';

import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_span.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_tracer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final carConnectionTracerProvider = Provider((ref) {
  return CarConnectionTracer(
    tracer: ref.watch(o11yTracerProvider),
  );
});

class CarConnectionTracer {
  CarConnectionTracer({
    required O11yTracer tracer,
  }) : _tracer = tracer;

  final O11yTracer _tracer;

  O11ySpan? _connectedSpan;
  O11ySpan? _lockUnlockDoorsSpan;
  Completer? _lockUnlockDoorsCompleter;
  O11ySpan? _updateSoftwareSpan;
  Completer? _updateSoftwareSpanCompleter;

  StatusCode? _lastFailedStatus;

  void connectedToCar() {
    _lastFailedStatus = null;
    _connectedSpan = _tracer.startSpan('Phone2Car-ConnectedToCar');

    // TODO: Add this!
    // applySpanAttributes()
  }

  void disconnectedFromCar() {
    if (_lastFailedStatus != null) {
      _connectedSpan?.setStatus(_lastFailedStatus!);
    } else {
      _connectedSpan?.setStatus(StatusCode.ok);
    }
    _connectedSpan?.end();
    _connectedSpan = null;
    _lastFailedStatus = null;
  }

  void startLockUnlockDoorsSpan({required bool shouldLock}) {
    final lockUnlockDoorsCompleter = Completer();
    _lockUnlockDoorsCompleter?.complete();
    _lockUnlockDoorsCompleter = lockUnlockDoorsCompleter;

    _tracer.executeWithParentSpan(
      parentSpan: _connectedSpan,
      work: () async {
        if (shouldLock) {
          _lockUnlockDoorsSpan = _tracer.startSpan('Phone2Car-LockDoors');
        } else {
          _lockUnlockDoorsSpan = _tracer.startSpan('Phone2Car-UnlockDoors');
        }

        // TODO: Add this!
        // applySpanAttributes()

        await lockUnlockDoorsCompleter.future;
      },
    );
  }

  void endLockUnlockDoorSpan({
    required bool shouldLock,
    required StatusCode status,
    String? message,
  }) {
    if (status == StatusCode.error) {
      _lastFailedStatus = status;
    }

    _lockUnlockDoorsSpan?.setStatus(status, message: message);
    _lockUnlockDoorsSpan?.end();
    _lockUnlockDoorsSpan = null;
    _lockUnlockDoorsCompleter?.complete();
    _lockUnlockDoorsCompleter = null;
  }

  void startUpdateSoftwareSpan() {
    final updateSoftwareSpanCompleter = Completer();
    _updateSoftwareSpanCompleter?.complete();
    _updateSoftwareSpanCompleter = updateSoftwareSpanCompleter;

    _tracer.executeWithParentSpan(
      parentSpan: _connectedSpan,
      work: () async {
        _updateSoftwareSpan = _tracer.startSpan('Phone2Car-UpdateSoftware');

        // TODO: Add this!
        // applySpanAttributes()

        await updateSoftwareSpanCompleter.future;
      },
    );
  }

  void addEventToSoftwareUpdateSpan(String event) {
    _updateSoftwareSpan?.addEvent(event);
  }

  void endUpdateSoftwareSpan({
    required StatusCode status,
    String? message,
  }) {
    if (status == StatusCode.error) {
      _lastFailedStatus = status;
    }

    _updateSoftwareSpan?.setStatus(status, message: message);
    _updateSoftwareSpan?.end();
    _updateSoftwareSpan = null;
    _updateSoftwareSpanCompleter?.complete();
    _updateSoftwareSpanCompleter = null;
  }
}
