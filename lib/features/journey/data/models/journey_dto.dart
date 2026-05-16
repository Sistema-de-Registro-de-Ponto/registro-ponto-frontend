import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

import 'journey_planned_activity_dto.dart';
import 'journey_unplanned_activity_dto.dart';

class JourneyDto {
  final int id;
  final int collaboratorId;
  final DateTime startedAt;
  final List<JourneyPlannedActivityDto> plannedActivities;
  final List<JourneyUnplannedActivityDto> unplannedActivities;
  final JourneyStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JourneyDto({
    required this.id,
    required this.collaboratorId,
    required this.startedAt,
    required this.plannedActivities,
    this.unplannedActivities = const [],
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JourneyDto.fromJson(Map<String, dynamic> json) {
    final activitiesJson = json['journey_planned_activities'];
    final activities = activitiesJson is List<dynamic>
        ? activitiesJson
              .whereType<Map<String, dynamic>>()
              .map(JourneyPlannedActivityDto.fromJson)
              .toList()
        : <JourneyPlannedActivityDto>[];

    final unplannedJson = json['unplanned_activities'];
    final unplanned = unplannedJson is List<dynamic>
        ? unplannedJson
              .whereType<Map<String, dynamic>>()
              .map(JourneyUnplannedActivityDto.fromJson)
              .toList()
        : <JourneyUnplannedActivityDto>[];

    return JourneyDto(
      id: json['id'] as int,
      collaboratorId: json['collaborator_id'] as int,
      startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
      plannedActivities: activities,
      unplannedActivities: unplanned,
      status: JourneyStatus.fromApi(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String).toLocal(),
      updatedAt: DateTime.parse(json['updated_at'] as String).toLocal(),
    );
  }

  Journey toEntity() {
    return Journey(
      id: id,
      collaboratorId: collaboratorId,
      startedAt: startedAt,
      plannedActivities: plannedActivities
          .map((dto) => dto.toEntity())
          .toList(),
      unplannedActivities: unplannedActivities
          .map((dto) => dto.toEntity())
          .toList(),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
