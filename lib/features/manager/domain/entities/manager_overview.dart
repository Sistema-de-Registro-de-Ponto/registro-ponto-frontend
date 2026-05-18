import 'package:equatable/equatable.dart';

class ManagerOverview extends Equatable {
  final int durationSeconds;
  final int journeysInProgress;
  final int averageAdherencePercentage;
  final int activitiesCompleted;
  final int unplannedActivities;

  const ManagerOverview({
    required this.durationSeconds,
    required this.journeysInProgress,
    required this.averageAdherencePercentage,
    required this.activitiesCompleted,
    required this.unplannedActivities,
  });

  @override
  List<Object?> get props => [
    durationSeconds,
    journeysInProgress,
    averageAdherencePercentage,
    activitiesCompleted,
    unplannedActivities,
  ];
}
