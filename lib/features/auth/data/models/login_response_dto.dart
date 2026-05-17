import '../../domain/entities/user_role.dart';

class LoginResponseDto {
  final String token;
  final String tokenType;
  final UserRole role;

  const LoginResponseDto({required this.token, required this.tokenType, required this.role});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String,
      role: UserRole.fromApiValue(json['role'] as String),
    );
  }
}
