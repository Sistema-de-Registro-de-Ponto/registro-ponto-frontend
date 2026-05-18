import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/manager_repository_provider.dart';
import '../../domain/entities/manager_consolidated_report.dart';
import 'manager_reports_state.dart';

part 'manager_reports_view_model.g.dart';

@riverpod
class ManagerReportsViewModel extends _$ManagerReportsViewModel {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  late final _repository = ref.read(managerRepositoryProvider);
  Timer? _searchDebounce;

  @override
  ManagerReportsState build() {
    ref.onDispose(() => _searchDebounce?.cancel());

    final today = DateTime.now().dateOnly;

    return ManagerReportsState(startDate: today, endDate: today);
  }

  Future<void> loadReport() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchConsolidatedReport(
      startDate: state.startDate,
      endDate: state.endDate,
      page: state.page,
      pageSize: state.pageSize,
      search: state.searchQuery.isEmpty ? null : state.searchQuery,
    );

    if (!ref.mounted) return;

    switch (result) {
      case Success<ManagerConsolidatedReport, String>():
        final report = result.value;
        final page = report.collaborators;
        state = state.copyWith(
          isLoading: false,
          startDate: report.startDate,
          endDate: report.endDate,
          summary: () => report.summary,
          collaborators: page.content,
          page: page.pageNumber,
          pageSize: page.pageSize,
          totalElements: page.totalElements,
          failure: () => null,
        );
      case Failure<ManagerConsolidatedReport, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!ref.mounted) return;

      state = state.copyWith(searchQuery: query, page: 0);
      loadReport();
    });
  }

  Future<void> changePeriod(DateTimeRange range) async {
    state = state.copyWith(
      startDate: range.start.dateOnly,
      endDate: range.end.dateOnly,
      page: 0,
    );

    await loadReport();
  }

  Future<void> changePage(int page) async {
    state = state.copyWith(page: page);
    await loadReport();
  }

  Future<void> changePageSize(int pageSize) async {
    state = state.copyWith(pageSize: pageSize, page: 0);
    await loadReport();
  }
}
