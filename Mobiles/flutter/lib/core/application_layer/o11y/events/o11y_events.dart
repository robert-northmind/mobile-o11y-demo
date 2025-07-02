import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/local_o11y/local_events.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final o11yEventsProvider = Provider((ref) {
  // return LocalO11yEvents();

  return O11yEvents(
    faro: ref.watch(faroProvider),
  );
});

class O11yEvents {
  O11yEvents({
    required Faro faro,
  }) : _faro = faro;

  final Faro _faro;

  void trackEvent(String name, {Map<String, String> attributes = const {}}) {
    _faro.pushEvent(name, attributes: attributes);
  }

  void trackStartEvent(String key, String name) {
    _faro.markEventStart(key, name);
  }

  void trackEndEvent(
    String key,
    String name, {
    Map<String, String> attributes = const {},
  }) {
    _faro.markEventEnd(key, name, attributes: attributes);
  }

  void setUser({
    required String id,
    required String name,
    required String email,
  }) {
    _faro.setUserMeta(
      userId: id,
      userName: name,
      userEmail: email,
    );
  }
}
