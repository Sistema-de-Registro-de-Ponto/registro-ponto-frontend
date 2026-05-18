import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_journey_list_item.dart';

class ManagerJourneyListItemDto {
  final int id;
  final DateTime journeyDate;
  final int collaboratorId;
  final String collaboratorFirstName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final JourneyStatus status;

  const ManagerJourneyListItemDto({
    required this.id,
    required this.journeyDate,
    required this.collaboratorId,
    required this.collaboratorFirstName,
    required this.startedAt,
    this.endedAt,
    this.duration,
    required this.status,
  });

  static Duration? _durationFromJson(dynamic raw) {
    if (raw == null) return null;
    if (raw is int) return Duration(seconds: raw);
    if (raw is num) return Duration(seconds: raw.round());
    return null;
  }

  factory ManagerJourneyListItemDto.fromJson(Map<String, dynamic> json) {
    final endedRaw = json['ended_at'];
    final endedAt = endedRaw is String
        ? DateTime.tryParse(endedRaw)?.toLocal()
        : null;

    return ManagerJourneyListItemDto(
      id: json['id'] as int,
      journeyDate: DateTime.parse(json['journey_date'] as String).dateOnly,
      collaboratorId: json['collaborator_id'] as int,
      collaboratorFirstName: json['collaborator_first_name'] as String,
      startedAt: DateTime.parse(json['started_at'] as String).toLocal(),
      endedAt: endedAt,
      duration: _durationFromJson(json['duration_seconds']),
      status: JourneyStatus.fromApi(json['status'] as String),
    );
  }

  ManagerJourneyListItem toEntity() {
    return ManagerJourneyListItem(
      id: id,
      journeyDate: journeyDate,
      collaboratorId: collaboratorId,
      collaboratorFirstName: collaboratorFirstName,
      startedAt: startedAt,
      endedAt: endedAt,
      duration: duration,
      status: status,
    );
  }
}
