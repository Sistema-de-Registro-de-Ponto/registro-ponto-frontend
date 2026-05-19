import 'dart:async';

import 'package:flutter/material.dart' hide Page;
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/pagination/page.dart';
import '../../../../core/utils/result.dart';
import '../../data/repositories/manager_repository_provider.dart';
import '../../domain/entities/manager_rpa_record.dart';
import 'manager_rpa_state.dart';

part 'manager_rpa_view_model.g.dart';

@riverpod
class ManagerRpaViewModel extends _$ManagerRpaViewModel {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  late final _repository = ref.read(managerRepositoryProvider);
  Timer? _searchDebounce;

  @override
  ManagerRpaState build() {
    ref.onDispose(() => _searchDebounce?.cancel());

    final today = DateTime.now().dateOnly;

    return ManagerRpaState(startDate: today, endDate: today);
  }

  Future<void> loadRecords() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchRpaRecords(
      page: state.page,
      pageSize: state.pageSize,
      startDate: state.usesPeriodFilter ? state.startDate : null,
      endDate: state.usesPeriodFilter ? state.endDate : null,
      search: state.searchQuery.isEmpty ? null : state.searchQuery,
    );

    if (!ref.mounted) return;

    switch (result) {
      case Success<Page<ManagerRpaRecord>, String>():
        final page = result.value;
        state = state.copyWith(
          isLoading: false,
          records: page.content,
          page: page.pageNumber,
          pageSize: page.pageSize,
          totalElements: page.totalElements,
          failure: () => null,
        );
      case Failure<Page<ManagerRpaRecord>, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!ref.mounted) return;

      state = state.copyWith(searchQuery: query, page: 0);
      loadRecords();
    });
  }

  Future<void> changePeriod(DateTimeRange range) async {
    state = state.copyWith(
      startDate: range.start.dateOnly,
      endDate: range.end.dateOnly,
      usesPeriodFilter: true,
      page: 0,
    );

    await loadRecords();
  }

  Future<void> changePage(int page) async {
    state = state.copyWith(page: page);
    await loadRecords();
  }

  Future<void> changePageSize(int pageSize) async {
    state = state.copyWith(pageSize: pageSize, page: 0);
    await loadRecords();
  }
}
