import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/traces/o11y_traces.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final carConnectionTracerProvider = Provider((ref) {
  return CarConnectionTracer(
    traces: ref.watch(o11yTracesProvider),
  );
});

class CarConnectionTracer {
  CarConnectionTracer({
    required O11yTraces traces,
  }) : _traces = traces;

  final O11yTraces _traces;

  Span? _connectedSpan;

  SpanStatusCode? _lastFailedStatus;

  void connectedToCar() {
    _lastFailedStatus = null;
    _connectedSpan = _traces.startSpanManual('Phone2Car-ConnectedToCar');
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

  Future<void> startLockUnlockDoorsSpan({
    required bool shouldLock,
    required Future<void> Function() action,
  }) async {
    final spanName =
        shouldLock ? 'Phone2Car-LockDoors' : 'Phone2Car-UnlockDoors';
    await _traces.startSpan(spanName, (span) async {
      try {
        await action();
      } catch (_) {
        _lastFailedStatus = SpanStatusCode.error;
        rethrow;
      }
    }, parentSpan: _connectedSpan);
  }

  Future<void> startUpdateSoftwareSpan({
    required Future<void> Function(Span) action,
  }) async {
    await _traces.startSpan('Phone2Car-UpdateSoftware', (span) async {
      try {
        await action(span);
      } catch (_) {
        _lastFailedStatus = SpanStatusCode.error;
        rethrow;
      }
    }, parentSpan: _connectedSpan);
  }

  void addEventToSoftwareUpdateSpan(String event) {
    _traces.getActiveSpan()?.addEvent(event);
  }
}
