import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';

class JourneyUnplannedActivityDto {
  final int id;
  final int journeyId;
  final String description;
  final DateTime createdAt;

  const JourneyUnplannedActivityDto({
    required this.id,
    required this.journeyId,
    required this.description,
    required this.createdAt,
  });

  factory JourneyUnplannedActivityDto.fromJson(Map<String, dynamic> json) {
    return JourneyUnplannedActivityDto(
      id: json['id'] as int,
      journeyId: json['journey_id'] as int,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
    );
  }

  JourneyUnplannedActivity toEntity() {
    return JourneyUnplannedActivity(
      id: id,
      journeyId: journeyId,
      description: description,
      createdAt: createdAt,
    );
  }
}
