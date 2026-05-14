import '../../domain/entities/user.dart';

class UserDto {
  final String username;
  final List<String> roles;

  const UserDto({
    required this.username,
    required this.roles,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      username: json['username'] as String,
      roles: (json['roles'] as List<dynamic>).cast<String>(),
    );
  }

  User toEntity() => User(username: username, roles: roles);
}
