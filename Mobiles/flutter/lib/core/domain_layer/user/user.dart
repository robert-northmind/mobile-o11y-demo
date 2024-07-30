import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.email,
  });

  final String id;
  final String username;
  final String email;

  @override
  List<Object?> get props => [id, username, email];
}
