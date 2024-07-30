import 'package:flutter_mobile_o11y_demo/core/domain_layer/user/user.dart';
import 'package:flutter_mobile_o11y_demo/core/utils/random_element.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userFactoryProvider = Provider((ref) {
  return UserFactory();
});

class UserFactory {
  final List<User> sampleUsers = const [
    User(id: '1', username: 'Funny Bunny', email: 'bunny@carrotmail.com'),
    User(id: '2', username: 'Cool Cat', email: 'coolcat@meowmail.com'),
    User(id: '3', username: 'Silly Goose', email: 'goose@gaggles.net'),
    User(id: '4', username: 'Happy Hippo', email: 'hippo@riverparty.com'),
    User(id: '5', username: 'Quirky Quokka', email: 'quokka@marsupialmail.com'),
  ];

  User createUser() {
    return sampleUsers.getRandomElement();
  }
}
