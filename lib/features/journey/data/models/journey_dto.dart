import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

import 'journey_planned_activity_dto.dart';
import 'journey_unplanned_activity_dto.dart';

class JourneyDto {
  final int id;
  final int collaboratorId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final String? summary;
  final List<JourneyPlannedActivityDto> plannedActivities;
  final List<JourneyUnplannedActivityDto> unplannedActivities;
  final JourneyStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const JourneyDto({
    required this.id,
    required this.collaboratorId,
    required this.startedAt,
    this.endedAt,
    this.duration,
    this.summary,
    required this.plannedActivities,
    this.unplannedActivities = const [],
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  static Duration? _durationFromJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return Duration(seconds: raw);
    if (raw is num) return Duration(seconds: raw.round());
    return null;
  }

  factory JourneyDto.fromResponseJson(Map<String, dynamic> json) {
    final journeyJson = json['journey'];
    if (journeyJson is Map<String, dynamic>) {
      return JourneyDto.fromJson(journeyJson);
    }
    return JourneyDto.fromJson(json);
  }

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

    final endedRaw = json['ended_at'];
    final endedAt = endedRaw is String
        ? DateTime.tryParse(endedRaw)?.toLocal()
        : null;

    final summaryRaw = json['summary'];
    final summary = summaryRaw is String ? summaryRaw : null;

    return JourneyDto(
      id: json['id'] as int,
      collaboratorId: json['collaborator_id'] as int,
      startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
      endedAt: endedAt,
      duration: _durationFromJson(json['duration_seconds']),
      summary: summary,
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
      endedAt: endedAt,
      duration: duration,
      summary: summary,
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
