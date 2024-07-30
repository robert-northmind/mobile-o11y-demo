import 'package:flutter_mobile_o11y_demo/core/application_layer/o11y/events/o11y_events.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/user/user.dart';
import 'package:flutter_mobile_o11y_demo/core/domain_layer/user/user_factory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

final currentUserServiceProvider = Provider((ref) {
  final service = CurrentUserService(
    userFactory: ref.watch(userFactoryProvider),
    o11yEvents: ref.watch(o11yEventsProvider),
  );
  ref.onDispose(service.dispose);
  return service;
});

class CurrentUserService {
  CurrentUserService({
    required UserFactory userFactory,
    required O11yEvents o11yEvents,
  }) {
    final user = userFactory.createUser();
    _userSubject.value = user;
    o11yEvents.setUser(id: user.id, name: user.username, email: user.email);
  }

  final _userSubject = BehaviorSubject<User?>.seeded(null);

  Stream<User?> get userStream => _userSubject.stream;
  User? get user => _userSubject.value;

  void dispose() {
    _userSubject.close();
  }
}
