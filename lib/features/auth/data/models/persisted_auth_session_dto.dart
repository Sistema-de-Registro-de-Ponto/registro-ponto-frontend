import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user_role.dart';

class PersistedAuthSessionDto {
  final String token;
  final String tokenType;
  final String role;

  const PersistedAuthSessionDto({required this.token, required this.tokenType, required this.role});

  factory PersistedAuthSessionDto.fromJson(Map<String, dynamic> json) {
    return PersistedAuthSessionDto(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'token': token, 'tokenType': tokenType, 'role': role};

  factory PersistedAuthSessionDto.fromEntity(AuthSession session) {
    return PersistedAuthSessionDto(
      token: session.token,
      tokenType: session.tokenType,
      role: session.role.apiValue,
    );
  }

  AuthSession toEntity() {
    return AuthSession(
      token: token,
      tokenType: tokenType,
      role: UserRole.fromApiValue(role),
    );
  }
}
