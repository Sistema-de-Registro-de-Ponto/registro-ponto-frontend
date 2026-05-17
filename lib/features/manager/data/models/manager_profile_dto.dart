import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_profile.dart';

class ManagerProfileDto {
  final int userId;
  final String firstName;

  const ManagerProfileDto({required this.userId, required this.firstName});

  factory ManagerProfileDto.fromJson(Map<String, dynamic> json) {
    return ManagerProfileDto(userId: json['user_id'] as int, firstName: json['first_name'] as String);
  }

  ManagerProfile toEntity() {
    return ManagerProfile(userId: userId, firstName: firstName);
  }
}
