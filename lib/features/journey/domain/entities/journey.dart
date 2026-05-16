import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

import 'journey_planned_activity.dart';
import 'journey_status.dart';
import 'journey_unplanned_activity.dart';

class Journey extends Equatable {
  final int id;
  final int collaboratorId;
  final DateTime startedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final String? summary;
  final List<JourneyPlannedActivity> plannedActivities;
  final List<JourneyUnplannedActivity> unplannedActivities;
  final JourneyStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Journey({
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

  String get startedHourLabel => startedAt.formattedHourShort;

  String get historyDateLabel => startedAt.formattedShortDate;

  String get historyWeekdayLabel => startedAt.formattedWeekday;

  String get historyEntryLabel => startedHourLabel;

  String get historyExitLabel => endedAt?.formattedHourShort ?? '--:--';

  bool get isHistoryInProgress => status == JourneyStatus.inProgress;

  String get historyStatusLabel => switch (status) {
    JourneyStatus.inProgress => 'Em andamento',
    JourneyStatus.completed => 'Finalizada',
    JourneyStatus.waiting => 'Aguardando',
  };

  int? get adherencePercent {
    if (plannedActivities.isEmpty) return null;

    final checkedCount = plannedActivities
        .where((activity) => activity.checked)
        .length;

    return ((checkedCount / plannedActivities.length) * 100).round();
  }

  String get adherenceLabel =>
      adherencePercent == null ? '-' : '$adherencePercent%';

  Duration displayDuration(DateTime at) =>
      duration ?? at.elapsedSince(startedAt);

  String historyTotalHoursLabel(DateTime at) => displayDuration(at).formattedHm;

  Journey withUpdatedPlannedActivity(JourneyPlannedActivity updated) {
    return Journey(
      id: id,
      collaboratorId: collaboratorId,
      startedAt: startedAt,
      endedAt: endedAt,
      duration: duration,
      summary: summary,
      plannedActivities: plannedActivities
          .map((item) => item.id == updated.id ? updated : item)
          .toList(),
      unplannedActivities: unplannedActivities,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Journey withAppendedUnplannedActivity(JourneyUnplannedActivity activity) {
    return Journey(
      id: id,
      collaboratorId: collaboratorId,
      startedAt: startedAt,
      endedAt: endedAt,
      duration: duration,
      summary: summary,
      plannedActivities: plannedActivities,
      unplannedActivities: [activity, ...unplannedActivities],
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Journey withoutUnplannedActivity(int activityId) {
    return Journey(
      id: id,
      collaboratorId: collaboratorId,
      startedAt: startedAt,
      endedAt: endedAt,
      duration: duration,
      summary: summary,
      plannedActivities: plannedActivities,
      unplannedActivities: unplannedActivities
          .where((item) => item.id != activityId)
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
    endedAt,
    duration,
    summary,
    plannedActivities,
    unplannedActivities,
    status,
    createdAt,
    updatedAt,
  ];
}
