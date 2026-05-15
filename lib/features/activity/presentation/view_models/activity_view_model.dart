import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/activity_repository_provider.dart';
import '../../domain/entities/planned_activity.dart';
import 'activity_state.dart';

part 'activity_view_model.g.dart';

@riverpod
class ActivityViewModel extends _$ActivityViewModel {
  late final _repository = ref.read(activityRepositoryProvider);

  @override
  ActivityState build() {
    Future.microtask(loadPlannedActivities);
    return const ActivityState();
  }

  void setDescription(String value) {
    state = state.copyWith(
      description: value,
      descriptionErrorText: () => null,
    );
  }

  Future<void> loadPlannedActivities() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchPlannedActivities();
    if (!ref.mounted) return;

    switch (result) {
      case Success<List<PlannedActivity>, String>():
        state = state.copyWith(isLoading: false, activities: _newestFirst(result.value));
      case Failure<List<PlannedActivity>, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<void> submitPlannedActivity() async {
    final trimmed = state.description.trim();
    if (trimmed.isEmpty) {
      state = state.copyWith(descriptionErrorText: () => 'Campo obrigatório');
      return;
    }

    state = state.copyWith(
      isLoading: true,
      descriptionErrorText: () => null,
      failure: () => null,
    );

    final result = await _repository.createPlannedActivity(
      description: trimmed,
    );
    if (!ref.mounted) return;

    switch (result) {
      case Success<PlannedActivity, String>():
        state = state.copyWith(
          isLoading: false,
          description: '',
          activities: _newestFirst([result.value, ...state.activities]),
        );
      case Failure<PlannedActivity, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<void> deletePlannedActivity(int id) async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.deletePlannedActivity(id: id);
    if (!ref.mounted) return;

    switch (result) {
      case Success<PlannedActivity, String>():
        state = state.copyWith(
          isLoading: false,
          activities: state.activities.where((item) => item.id != id).toList(),
        );
      case Failure<PlannedActivity, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  List<PlannedActivity> _newestFirst(List<PlannedActivity> activities) {
    return [...activities]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }
}
