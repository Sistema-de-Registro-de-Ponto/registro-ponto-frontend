import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';

class JourneyPlannedActivityDto {
  final int id;
  final int plannedActivityId;
  final String description;
  final bool checked;

  const JourneyPlannedActivityDto({
    required this.id,
    required this.plannedActivityId,
    required this.description,
    required this.checked,
  });

  factory JourneyPlannedActivityDto.fromJson(Map<String, dynamic> json) {
    return JourneyPlannedActivityDto(
      id: json['id'] as int,
      plannedActivityId: json['planned_activity_id'] as int,
      description: json['description'] as String,
      checked: json['checked'] as bool,
    );
  }

  JourneyPlannedActivity toEntity() {
    return JourneyPlannedActivity(
      id: id,
      plannedActivityId: plannedActivityId,
      description: description,
      checked: checked,
    );
  }
}
