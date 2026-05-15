import 'package:registro_ponto_frontend/features/colaborador/domain/entities/colaborador_profile.dart';

class ColaboradorProfileDto {
  final int userId;
  final String firstName;

  const ColaboradorProfileDto({required this.userId, required this.firstName});

  factory ColaboradorProfileDto.fromJson(Map<String, dynamic> json) {
    return ColaboradorProfileDto(userId: json['user_id'] as int, firstName: json['first_name'] as String);
  }

  ColaboradorProfile toEntity() {
    return ColaboradorProfile(userId: userId, firstName: firstName);
  }
}
