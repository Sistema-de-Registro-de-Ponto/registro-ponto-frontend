import '../../domain/entities/manager_overview.dart';

class ManagerOverviewDto {
  final int durationSeconds;
  final int journeysInProgress;
  final int averageAdherencePercentage;
  final int activitiesCompleted;
  final int unplannedActivities;

  const ManagerOverviewDto({
    required this.durationSeconds,
    required this.journeysInProgress,
    required this.averageAdherencePercentage,
    required this.activitiesCompleted,
    required this.unplannedActivities,
  });

  factory ManagerOverviewDto.fromJson(Map<String, dynamic> json) {
    return ManagerOverviewDto(
      durationSeconds: json['duration_seconds'] as int,
      journeysInProgress: json['journeys_progress'] as int,
      averageAdherencePercentage: json['average_adherence_percentage'] as int,
      activitiesCompleted: json['activities_completed'] as int,
      unplannedActivities: json['unplanned_activities'] as int,
    );
  }

  ManagerOverview toEntity() {
    return ManagerOverview(
      durationSeconds: durationSeconds,
      journeysInProgress: journeysInProgress,
      averageAdherencePercentage: averageAdherencePercentage,
      activitiesCompleted: activitiesCompleted,
      unplannedActivities: unplannedActivities,
    );
  }
}
