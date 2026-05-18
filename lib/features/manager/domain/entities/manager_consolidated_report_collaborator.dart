import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

class ManagerConsolidatedReportCollaborator extends Equatable {
  final int id;
  final String firstName;
  final int durationSeconds;
  final int plannedActivities;
  final int activitiesCompleted;
  final int unplannedActivities;
  final int adherencePercentage;

  const ManagerConsolidatedReportCollaborator({
    required this.id,
    required this.firstName,
    required this.durationSeconds,
    required this.plannedActivities,
    required this.activitiesCompleted,
    required this.unplannedActivities,
    required this.adherencePercentage,
  });

  String get durationLabel => Duration(seconds: durationSeconds).formattedHm;

  String get adherenceLabel => '$adherencePercentage%';

  @override
  List<Object?> get props => [
    id,
    firstName,
    durationSeconds,
    plannedActivities,
    activitiesCompleted,
    unplannedActivities,
    adherencePercentage,
  ];
}
