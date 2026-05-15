import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';

class ActivityState extends Equatable {
  final String description;
  final List<PlannedActivity> activities;
  final bool isLoading;
  final String? descriptionErrorText;
  final String? failure;

  const ActivityState({
    this.description = '',
    this.activities = const [],
    this.isLoading = false,
    this.descriptionErrorText,
    this.failure,
  });

  ActivityState copyWith({
    String? description,
    List<PlannedActivity>? activities,
    bool? isLoading,
    ValueGetter<String?>? descriptionErrorText,
    ValueGetter<String?>? failure,
  }) {
    return ActivityState(
      description: description ?? this.description,
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      descriptionErrorText: descriptionErrorText != null
          ? descriptionErrorText()
          : this.descriptionErrorText,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    description,
    activities,
    isLoading,
    descriptionErrorText,
    failure,
  ];
}
