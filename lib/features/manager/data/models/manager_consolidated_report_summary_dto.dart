import '../../domain/entities/manager_consolidated_report_summary.dart';

class ManagerConsolidatedReportSummaryDto {
  final int durationSeconds;
  final int plannedActivities;
  final int activitiesCompleted;
  final int unplannedActivities;
  final int averageAdherencePercentage;

  const ManagerConsolidatedReportSummaryDto({
    required this.durationSeconds,
    required this.plannedActivities,
    required this.activitiesCompleted,
    required this.unplannedActivities,
    required this.averageAdherencePercentage,
  });

  factory ManagerConsolidatedReportSummaryDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ManagerConsolidatedReportSummaryDto(
      durationSeconds: json['duration_seconds'] as int,
      plannedActivities: json['planned_activities'] as int,
      activitiesCompleted: json['activities_completed'] as int,
      unplannedActivities: json['unplanned_activities'] as int,
      averageAdherencePercentage: json['average_adherence_percentage'] as int,
    );
  }

  ManagerConsolidatedReportSummary toEntity() {
    return ManagerConsolidatedReportSummary(
      durationSeconds: durationSeconds,
      plannedActivities: plannedActivities,
      activitiesCompleted: activitiesCompleted,
      unplannedActivities: unplannedActivities,
      averageAdherencePercentage: averageAdherencePercentage,
    );
  }
}
