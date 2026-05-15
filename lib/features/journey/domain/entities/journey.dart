import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

import 'journey_planned_activity.dart';
import 'journey_status.dart';

class Journey extends Equatable {
  final int id;
  final int collaboratorId;
  final DateTime startedAt;
  final List<JourneyPlannedActivity> plannedActivities;
  final JourneyStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Journey({
    required this.id,
    required this.collaboratorId,
    required this.startedAt,
    required this.plannedActivities,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String get startedHourLabel => startedAt.formattedHourShort;

  Journey withUpdatedPlannedActivity(JourneyPlannedActivity updated) {
    return Journey(
      id: id,
      collaboratorId: collaboratorId,
      startedAt: startedAt,
      plannedActivities: plannedActivities
          .map((item) => item.id == updated.id ? updated : item)
          .toList(),
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    collaboratorId,
    startedAt,
    plannedActivities,
    status,
    createdAt,
    updatedAt,
  ];
}
