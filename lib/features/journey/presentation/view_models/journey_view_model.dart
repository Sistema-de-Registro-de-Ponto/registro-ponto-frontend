import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/journey_repository_provider.dart';
import '../../domain/entities/journey.dart';
import '../../domain/entities/journey_planned_activity.dart';
import '../../domain/entities/journey_status.dart';
import '../../domain/entities/journey_unplanned_activity.dart';
import 'journey_state.dart';

part 'journey_view_model.g.dart';

@riverpod
class JourneyViewModel extends _$JourneyViewModel {
  late final _repository = ref.read(journeyRepositoryProvider);

  @override
  JourneyState build() => const JourneyState();

  Future<void> loadInProgressJourney() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchInProgressJourney();
    if (!ref.mounted) return;

    switch (result) {
      case Success<Journey?, String>():
        final keepFormFields = result.value != null;
        state = JourneyState(
          isLoading: false,
          journey: result.value,
          unplannedDescription: keepFormFields
              ? state.unplannedDescription
              : '',
          unplannedDescriptionErrorText: keepFormFields
              ? state.unplannedDescriptionErrorText
              : null,
        );
      case Failure<Journey?, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<void> startJourney() async {
    if (!state.canStartJourney) {
      state = state.copyWith(
        failure: () => 'Já existe uma jornada em andamento',
      );
      return;
    }

    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.startJourney();
    if (!ref.mounted) return;

    switch (result) {
      case Success<Journey, String>():
        state = state.copyWith(
          isLoading: false,
          journey: () => result.value,
          failure: () => null,
        );
      case Failure<Journey, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<bool> endJourney(String summary) async {
    if (!state.canEndJourney) {
      final current = state.journey;
      if (current != null && current.status != JourneyStatus.inProgress) {
        state = state.copyWith(
          failure: () => 'A jornada não está em andamento',
        );
      }
      return false;
    }

    state = state.copyWith(isEndingJourney: true, failure: () => null);

    final result = await _repository.endJourney(summary: summary.trim());
    if (!ref.mounted) return false;

    switch (result) {
      case Success<Journey, String>():
        state = state.copyWith(
          isEndingJourney: false,
          journey: () => null,
          failure: () => null,
          unplannedDescription: '',
          unplannedDescriptionErrorText: () => null,
        );
        return true;
      case Failure<Journey, String>():
        state = state.copyWith(
          isEndingJourney: false,
          failure: () => result.error,
        );
        return false;
    }
  }

  Future<void> setChecked(int journeyPlannedActivityId, bool checked) async {
    final journey = state.journey;
    if (journey == null ||
        !state.isJourneyInProgress ||
        state.togglingPlannedActivityId != null) {
      return;
    }

    state = state.copyWith(
      togglingPlannedActivityId: () => journeyPlannedActivityId,
      failure: () => null,
    );

    final result = await _repository.updatePlannedActivityChecked(
      journeyPlannedActivityId: journeyPlannedActivityId,
      checked: checked,
    );
    if (!ref.mounted) return;

    switch (result) {
      case Success<JourneyPlannedActivity, String>():
        final updatedJourney = journey.withUpdatedPlannedActivity(result.value);
        state = state.copyWith(
          journey: () => updatedJourney,
          togglingPlannedActivityId: () => null,
        );
      case Failure<JourneyPlannedActivity, String>():
        state = state.copyWith(
          togglingPlannedActivityId: () => null,
          failure: () => result.error,
        );
    }
  }

  void setUnplannedDescription(String value) {
    if (!state.isJourneyInProgress) return;

    state = state.copyWith(
      unplannedDescription: value,
      unplannedDescriptionErrorText: () => null,
    );
  }

  Future<void> submitUnplannedActivity() async {
    final journey = state.journey;
    if (journey == null || !state.isJourneyInProgress) return;
    if (state.isUnplannedMutationBusy) return;

    final trimmed = state.unplannedDescription.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(
        unplannedDescriptionErrorText: () => 'Campo obrigatório',
      );
      return;
    }

    state = state.copyWith(
      isUnplannedActivitySubmitting: true,
      unplannedDescriptionErrorText: () => null,
      failure: () => null,
    );

    final result = await _repository.createUnplannedActivity(
      journeyId: journey.id,
      description: trimmed,
    );
    if (!ref.mounted) return;

    switch (result) {
      case Success<JourneyUnplannedActivity, String>():
        state = state.copyWith(
          isUnplannedActivitySubmitting: false,
          unplannedDescription: '',
          journey: () => journey.withAppendedUnplannedActivity(result.value),
        );
      case Failure<JourneyUnplannedActivity, String>():
        state = state.copyWith(
          isUnplannedActivitySubmitting: false,
          failure: () => result.error,
        );
    }
  }

  Future<void> deleteUnplannedActivity(int id) async {
    final journey = state.journey;
    if (journey == null || !state.isJourneyInProgress) return;
    if (state.isUnplannedMutationBusy) return;

    state = state.copyWith(
      deletingUnplannedActivityId: () => id,
      failure: () => null,
    );

    final result = await _repository.deleteUnplannedActivity(id: id);
    if (!ref.mounted) return;

    switch (result) {
      case Success<int, String>():
        state = state.copyWith(
          deletingUnplannedActivityId: () => null,
          journey: () => journey.withoutUnplannedActivity(id),
        );
      case Failure<int, String>():
        state = state.copyWith(
          deletingUnplannedActivityId: () => null,
          failure: () => result.error,
        );
    }
  }
}
