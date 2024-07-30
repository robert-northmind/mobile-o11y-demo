import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/faro/faro.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rum_sdk/rum_flutter.dart';
import 'package:rum_sdk/rum_sdk.dart';

final o11yEventsProvider = Provider((ref) {
  return O11yEvents(
    rumFlutter: ref.watch(rumProvider),
  );
});

class O11yEvents {
  O11yEvents({
    required RumFlutter rumFlutter,
  }) : _rumFlutter = rumFlutter;

  final RumFlutter _rumFlutter;

  void trackEvent(String name, {Map<String, String> attributes = const {}}) {
    _rumFlutter.pushEvent(name, attributes: attributes);
  }

  void setUser({
    required String id,
    required String name,
    required String email,
  }) {
    _rumFlutter.setUserMeta(
      userId: id,
      userName: name,
      userEmail: email,
    );
  }
}
