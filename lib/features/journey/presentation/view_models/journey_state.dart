import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/shared/app_check_list_item.dart';
import 'package:registro_ponto_frontend/shared/app_journey.dart';

class JourneyState extends Equatable {
  final Journey? journey;
  final bool isLoading;
  final String? failure;
  final int? togglingPlannedActivityId;
  final String unplannedDescription;
  final String? unplannedDescriptionErrorText;
  final bool isUnplannedActivitySubmitting;
  final int? deletingUnplannedActivityId;

  const JourneyState({
    this.journey,
    this.isLoading = false,
    this.failure,
    this.togglingPlannedActivityId,
    this.unplannedDescription = '',
    this.unplannedDescriptionErrorText,
    this.isUnplannedActivitySubmitting = false,
    this.deletingUnplannedActivityId,
  });

  @override
  List<Object?> get props => [
    journey,
    isLoading,
    failure,
    togglingPlannedActivityId,
    unplannedDescription,
    unplannedDescriptionErrorText,
    isUnplannedActivitySubmitting,
    deletingUnplannedActivityId,
  ];

  bool get canStartJourney =>
      journey == null || journey?.status != JourneyStatus.inProgress;

  bool get isJourneyInProgress => journey?.status == JourneyStatus.inProgress;

  bool get showPlannedActivitiesChecklist {
    final current = journey;
    if (current == null || current.plannedActivities.isEmpty) return false;

    return current.status != JourneyStatus.inProgress;
  }

  bool get showUnplannedActivitiesPanel {
    final current = journey;
    if (current == null) return false;

    return current.status == JourneyStatus.inProgress;
  }

  bool get isUnplannedMutationBusy =>
      isUnplannedActivitySubmitting || deletingUnplannedActivityId != null;

  AppJourneyStatus get uiStatus {
    final current = journey;
    if (current == null) return AppJourneyStatus.waiting;

    return switch (current.status) {
      JourneyStatus.inProgress => AppJourneyStatus.inProgress,
      JourneyStatus.completed => AppJourneyStatus.completed,
      JourneyStatus.waiting => AppJourneyStatus.waiting,
    };
  }

  List<AppCheckListItem> buildChecklistItems({
    required void Function(int journeyPlannedActivityId, bool checked)
    onSetChecked,
    required bool allowToggle,
  }) {
    final activities = journey?.plannedActivities ?? const [];

    return activities
        .map(
          (activity) => AppCheckListItem(
            isChecked: activity.checked,
            title: activity.description,
            onTap: allowToggle
                ? () => onSetChecked(activity.id, !activity.checked)
                : null,
            isBusy: togglingPlannedActivityId == activity.id,
          ),
        )
        .toList();
  }

  JourneyState copyWith({
    Journey? journey,
    bool? isLoading,
    ValueGetter<String?>? failure,
    ValueGetter<int?>? togglingPlannedActivityId,
    String? unplannedDescription,
    ValueGetter<String?>? unplannedDescriptionErrorText,
    bool? isUnplannedActivitySubmitting,
    ValueGetter<int?>? deletingUnplannedActivityId,
  }) {
    return JourneyState(
      journey: journey ?? this.journey,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
      togglingPlannedActivityId: togglingPlannedActivityId != null
          ? togglingPlannedActivityId()
          : this.togglingPlannedActivityId,
      unplannedDescription: unplannedDescription ?? this.unplannedDescription,
      unplannedDescriptionErrorText: unplannedDescriptionErrorText != null
          ? unplannedDescriptionErrorText()
          : this.unplannedDescriptionErrorText,
      isUnplannedActivitySubmitting:
          isUnplannedActivitySubmitting ?? this.isUnplannedActivitySubmitting,
      deletingUnplannedActivityId: deletingUnplannedActivityId != null
          ? deletingUnplannedActivityId()
          : this.deletingUnplannedActivityId,
    );
  }
}
