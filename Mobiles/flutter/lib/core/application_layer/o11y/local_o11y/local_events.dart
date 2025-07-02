import 'package:faro/faro.dart';
import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/events/o11y_events.dart';

class LocalO11yEvents implements O11yEvents {
  @override
  void trackEvent(String name, {Map<String, String> attributes = const {}}) {
    print('LocalO11yEvents: trackEvent: $name, $attributes');
  }

  @override
  Faro get _faro => throw UnimplementedError();

  @override
  void setUser(
      {required String id, required String name, required String email}) {
    print('LocalO11yEvents: setUser: $id, $name, $email');
  }

  @override
  void trackEndEvent(String key, String name,
      {Map<String, String> attributes = const {}}) {
    print('LocalO11yEvents: trackEndEvent: $key, $name, $attributes');
  }

  @override
  void trackStartEvent(String key, String name) {
    print('LocalO11yEvents: trackStartEvent: $key, $name');
  }
}
