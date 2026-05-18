import 'package:equatable/equatable.dart';

class ManagerConsolidatedReportSummary extends Equatable {
  final int durationSeconds;
  final int plannedActivities;
  final int activitiesCompleted;
  final int unplannedActivities;
  final int averageAdherencePercentage;

  const ManagerConsolidatedReportSummary({
    required this.durationSeconds,
    required this.plannedActivities,
    required this.activitiesCompleted,
    required this.unplannedActivities,
    required this.averageAdherencePercentage,
  });

  @override
  List<Object?> get props => [
    durationSeconds,
    plannedActivities,
    activitiesCompleted,
    unplannedActivities,
    averageAdherencePercentage,
  ];
}
