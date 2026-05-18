import '../../domain/entities/manager_consolidated_report_collaborator.dart';

class ManagerConsolidatedReportCollaboratorDto {
  final int id;
  final String firstName;
  final int durationSeconds;
  final int plannedActivities;
  final int activitiesCompleted;
  final int unplannedActivities;
  final int adherencePercentage;

  const ManagerConsolidatedReportCollaboratorDto({
    required this.id,
    required this.firstName,
    required this.durationSeconds,
    required this.plannedActivities,
    required this.activitiesCompleted,
    required this.unplannedActivities,
    required this.adherencePercentage,
  });

  factory ManagerConsolidatedReportCollaboratorDto.fromJson(
    Map<String, dynamic> json,
  ) {
    return ManagerConsolidatedReportCollaboratorDto(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      durationSeconds: json['duration_seconds'] as int,
      plannedActivities: json['planned_activities'] as int,
      activitiesCompleted: json['activities_completed'] as int,
      unplannedActivities: json['unplanned_activities'] as int,
      adherencePercentage: json['adherence_percentage'] as int,
    );
  }

  ManagerConsolidatedReportCollaborator toEntity() {
    return ManagerConsolidatedReportCollaborator(
      id: id,
      firstName: firstName,
      durationSeconds: durationSeconds,
      plannedActivities: plannedActivities,
      activitiesCompleted: activitiesCompleted,
      unplannedActivities: unplannedActivities,
      adherencePercentage: adherencePercentage,
    );
  }
}
