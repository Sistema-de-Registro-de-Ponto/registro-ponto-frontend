import 'package:equatable/equatable.dart';

import 'user_role.dart';

class AuthSession extends Equatable {
  final String token;
  final String tokenType;
  final UserRole role;

  const AuthSession({required this.token, required this.tokenType, required this.role});

  @override
  List<Object?> get props => [token, tokenType, role];
}
