import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/manager_repository_provider.dart';
import '../../../../core/pagination/page.dart';
import '../../domain/entities/manager_collaborator.dart';
import '../../domain/entities/manager_collaborator_detail.dart';
import 'manager_collaborators_state.dart';

part 'manager_collaborators_view_model.g.dart';

@riverpod
class ManagerCollaboratorsViewModel extends _$ManagerCollaboratorsViewModel {
  static const _searchDebounceDuration = Duration(milliseconds: 400);

  late final _repository = ref.read(managerRepositoryProvider);
  Timer? _searchDebounce;

  @override
  ManagerCollaboratorsState build() {
    ref.onDispose(() => _searchDebounce?.cancel());

    return const ManagerCollaboratorsState();
  }

  Future<void> loadCollaborators() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _repository.fetchCollaborators(
      page: state.page,
      pageSize: state.pageSize,
      query: state.searchQuery.isEmpty ? null : state.searchQuery,
    );

    if (!ref.mounted) return;

    switch (result) {
      case Success<Page<ManagerCollaborator>, String>():
        final page = result.value;
        state = state.copyWith(
          isLoading: false,
          collaborators: page.content,
          page: page.pageNumber,
          pageSize: page.pageSize,
          totalElements: page.totalElements,
          failure: () => null,
        );
      case Failure<Page<ManagerCollaborator>, String>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  Future<ManagerCollaboratorDetail?> loadCollaboratorDetail(int id) async {
    state = state.copyWith(isLoadingDetail: true, failure: () => null);

    final result = await _repository.fetchCollaboratorById(id);

    if (!ref.mounted) return null;

    state = state.copyWith(isLoadingDetail: false);

    switch (result) {
      case Success<ManagerCollaboratorDetail, String>():
        return result.value;
      case Failure<ManagerCollaboratorDetail, String>():
        state = state.copyWith(failure: () => result.error);
        return null;
    }
  }

  void onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(_searchDebounceDuration, () {
      if (!ref.mounted) return;

      state = state.copyWith(searchQuery: query, page: 0);
      loadCollaborators();
    });
  }

  Future<void> changePage(int page) async {
    state = state.copyWith(page: page);
    await loadCollaborators();
  }

  Future<void> changePageSize(int pageSize) async {
    state = state.copyWith(pageSize: pageSize, page: 0);
    await loadCollaborators();
  }
}
