import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/manager_repository_provider.dart';
import '../../domain/entities/manager_overview.dart';
import 'manager_overview_state.dart';

part 'manager_overview_view_model.g.dart';

@riverpod
class ManagerOverviewViewModel extends _$ManagerOverviewViewModel {
  late final _repository = ref.read(managerRepositoryProvider);

  @override
  ManagerOverviewState build() {
    final today = DateTime.now().dateOnly;

    return ManagerOverviewState(startDate: today, endDate: today);
  }

  Future<void> loadOverview() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchOverview(
      startDate: state.startDate,
      endDate: state.endDate,
    );

    if (!ref.mounted) return;

    switch (result) {
      case Success<ManagerOverview, String>():
        state = state.copyWith(
          isLoading: false,
          overview: () => result.value,
          failure: () => null,
        );
      case Failure<ManagerOverview, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<void> changePeriod(DateTimeRange range) async {
    state = state.copyWith(
      startDate: range.start.dateOnly,
      endDate: range.end.dateOnly,
    );

    await loadOverview();
  }
}
