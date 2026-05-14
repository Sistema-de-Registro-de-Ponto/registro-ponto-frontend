import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';

class PersistedAuthSessionDto {
  final String token;
  final String tokenType;
  final String username;
  final List<String> roles;

  const PersistedAuthSessionDto({
    required this.token,
    required this.tokenType,
    required this.username,
    required this.roles,
  });

  factory PersistedAuthSessionDto.fromJson(Map<String, dynamic> json) {
    return PersistedAuthSessionDto(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String,
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'tokenType': tokenType,
        'username': username,
        'roles': roles,
      };

  factory PersistedAuthSessionDto.fromEntity(AuthSession session) {
    return PersistedAuthSessionDto(
      token: session.token,
      tokenType: session.tokenType,
      username: session.user.username,
      roles: session.user.roles,
    );
  }

  AuthSession toEntity() => AuthSession(
        token: token,
        tokenType: tokenType,
        user: User(username: username, roles: roles),
      );
}
