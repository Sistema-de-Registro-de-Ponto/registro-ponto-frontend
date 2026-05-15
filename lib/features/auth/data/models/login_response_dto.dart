class LoginResponseDto {
  final String token;
  final String tokenType;

  const LoginResponseDto({required this.token, required this.tokenType});

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      token: json['token'] as String,
      tokenType: json['tokenType'] as String,
    );
  }
}
