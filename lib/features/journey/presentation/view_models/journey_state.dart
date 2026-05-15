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

  const JourneyState({this.journey, this.isLoading = false, this.failure});

  @override
  List<Object?> get props => [journey, isLoading, failure];

  bool get canStartJourney =>
      journey == null || journey?.status != JourneyStatus.inProgress;

  bool get isJourneyInProgress => journey?.status == JourneyStatus.inProgress;

  bool get showPlannedActivitiesChecklist {
    final current = journey;
    if (current == null || current.plannedActivities.isEmpty) return false;

    return current.status == JourneyStatus.inProgress ||
        current.status == JourneyStatus.completed;
  }

  AppJourneyStatus get uiStatus {
    final current = journey;
    if (current == null) return AppJourneyStatus.waiting;

    return switch (current.status) {
      JourneyStatus.inProgress => AppJourneyStatus.inProgress,
      JourneyStatus.completed => AppJourneyStatus.completed,
      JourneyStatus.waiting => AppJourneyStatus.waiting,
    };
  }

  List<AppCheckListItem> get checklistItems {
    final activities = journey?.plannedActivities ?? const [];
    return activities
        .map(
          (activity) => AppCheckListItem(
            isChecked: activity.checked,
            title: activity.description,
          ),
        )
        .toList();
  }

  JourneyState copyWith({
    Journey? journey,
    bool? isLoading,
    ValueGetter<String?>? failure,
  }) {
    return JourneyState(
      journey: journey ?? this.journey,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
