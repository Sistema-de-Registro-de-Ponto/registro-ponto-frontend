import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/pagination/page.dart';
import '../../../../core/utils/result.dart';
import '../../../journey/domain/entities/journey.dart';
import '../../data/repositories/manager_repository_provider.dart';
import '../../domain/entities/manager_journey_list_item.dart';
import 'manager_journeys_state.dart';

part 'manager_journeys_view_model.g.dart';

@riverpod
class ManagerJourneysViewModel extends _$ManagerJourneysViewModel {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  late final _repository = ref.read(managerRepositoryProvider);
  Timer? _searchDebounce;

  @override
  ManagerJourneysState build() {
    ref.onDispose(() => _searchDebounce?.cancel());

    final today = DateTime.now().dateOnly;

    return ManagerJourneysState(startDate: today, endDate: today);
  }

  Future<void> loadJourneys() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchJourneys(
      page: state.page,
      pageSize: state.pageSize,
      startDate: state.usesPeriodFilter ? state.startDate : null,
      endDate: state.usesPeriodFilter ? state.endDate : null,
      collaboratorName: state.collaboratorNameQuery.isEmpty
          ? null
          : state.collaboratorNameQuery,
    );

    if (!ref.mounted) return;

    switch (result) {
      case Success<Page<ManagerJourneyListItem>, String>():
        final page = result.value;
        state = state.copyWith(
          isLoading: false,
          journeys: page.content,
          page: page.pageNumber,
          pageSize: page.pageSize,
          totalElements: page.totalElements,
          failure: () => null,
        );
      case Failure<Page<ManagerJourneyListItem>, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<Journey?> loadJourneyDetail(int id) async {
    state = state.copyWith(isLoadingDetail: true, failure: () => null);

    final result = await _repository.fetchJourneyById(id);

    if (!ref.mounted) return null;

    state = state.copyWith(isLoadingDetail: false);

    switch (result) {
      case Success<Journey, String>():
        return result.value;
      case Failure<Journey, String>():
        state = state.copyWith(failure: () => result.error);
        return null;
    }
  }

  void onCollaboratorNameChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!ref.mounted) return;

      state = state.copyWith(collaboratorNameQuery: query, page: 0);
      loadJourneys();
    });
  }

  Future<void> changePeriod(DateTimeRange range) async {
    state = state.copyWith(
      startDate: range.start.dateOnly,
      endDate: range.end.dateOnly,
      usesPeriodFilter: true,
      page: 0,
    );

    await loadJourneys();
  }

  Future<void> changePage(int page) async {
    state = state.copyWith(page: page);
    await loadJourneys();
  }

  Future<void> changePageSize(int pageSize) async {
    state = state.copyWith(pageSize: pageSize, page: 0);
    await loadJourneys();
  }
}
