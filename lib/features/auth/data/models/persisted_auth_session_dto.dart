import '../../domain/entities/auth_session.dart';

class PersistedAuthSessionDto {
  final String token;
  final String tokenType;

  const PersistedAuthSessionDto({required this.token, required this.tokenType});

  factory PersistedAuthSessionDto.fromJson(Map<String, dynamic> json) {
    return PersistedAuthSessionDto(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'token': token, 'tokenType': tokenType};

  factory PersistedAuthSessionDto.fromEntity(AuthSession session) {
    return PersistedAuthSessionDto(
      token: session.token,
      tokenType: session.tokenType,
    );
  }

  AuthSession toEntity() => AuthSession(token: token, tokenType: tokenType);
}
