import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String username;
  final List<String> roles;

  const User({
    required this.username,
    required this.roles,
  });

  @override
  List<Object?> get props => [username, roles];
}
