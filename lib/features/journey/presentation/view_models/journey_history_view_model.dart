import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/journey_repository_provider.dart';
import '../../domain/entities/journey_page.dart';
import 'journey_history_state.dart';

part 'journey_history_view_model.g.dart';

@riverpod
class JourneyHistoryViewModel extends _$JourneyHistoryViewModel {
  static const _defaultPeriodDays = 7;
  static const _pageSize = 20;

  late final _repository = ref.read(journeyRepositoryProvider);

  @override
  JourneyHistoryState build() {
    final endDate = _dateOnly(DateTime.now());
    final startDate = endDate.subtract(
      const Duration(days: _defaultPeriodDays - 1),
    );

    return JourneyHistoryState(startDate: startDate, endDate: endDate);
  }

  Future<void> loadJourneys({bool loadMore = false}) async {
    if (loadMore) {
      if (!state.hasMore || state.isLoadingMore || state.isLoading) return;

      state = state.copyWith(isLoadingMore: true, failure: () => null);
    } else {
      state = state.copyWith(
        isLoading: true,
        isLoadingMore: false,
        failure: () => null,
        journeys: () => [],
        hasMore: false,
        nextPage: 0,
      );
    }

    final pageToFetch = loadMore ? state.nextPage : 0;

    final result = await _repository.fetchJourneys(
      startDate: state.startDate,
      endDate: state.endDate,
      page: pageToFetch,
      pageSize: _pageSize,
    );

    if (!ref.mounted) return;

    switch (result) {
      case Success<JourneyPage, String>():
        _applyPage(result.value, pageToFetch: pageToFetch, loadMore: loadMore);
      case Failure<JourneyPage, String>():
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          failure: () => result.error,
        );
    }
  }

  Future<void> changePeriod(DateTimeRange range) async {
    state = state.copyWith(
      startDate: _dateOnly(range.start),
      endDate: _dateOnly(range.end),
    );

    await loadJourneys();
  }

  void _applyPage(
    JourneyPage page, {
    required int pageToFetch,
    required bool loadMore,
  }) {
    final mergedJourneys = loadMore
        ? [...state.journeys, ...page.journeys]
        : page.journeys;

    state = state.copyWith(
      isLoading: false,
      isLoadingMore: false,
      journeys: () => mergedJourneys,
      hasMore: page.hasMore,
      nextPage: page.hasMore ? pageToFetch + 1 : pageToFetch,
      failure: () => null,
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
