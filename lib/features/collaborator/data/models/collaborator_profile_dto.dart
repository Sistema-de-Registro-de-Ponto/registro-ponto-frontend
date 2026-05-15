import 'package:registro_ponto_frontend/features/collaborator/domain/entities/collaborator_profile.dart';

class CollaboratorProfileDto {
  final int userId;
  final String firstName;

  const CollaboratorProfileDto({required this.userId, required this.firstName});

  factory CollaboratorProfileDto.fromJson(Map<String, dynamic> json) {
    return CollaboratorProfileDto(userId: json['user_id'] as int, firstName: json['first_name'] as String);
  }

  CollaboratorProfile toEntity() {
    return CollaboratorProfile(userId: userId, firstName: firstName);
  }
}
