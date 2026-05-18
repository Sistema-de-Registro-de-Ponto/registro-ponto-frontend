import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';

class ManagerCollaboratorsState extends Equatable {
  static const defaultPageSize = 10;

  final List<ManagerCollaborator> collaborators;
  final int page;
  final int pageSize;
  final int totalElements;
  final String searchQuery;
  final bool isLoading;
  final bool isLoadingDetail;
  final String? failure;

  const ManagerCollaboratorsState({
    this.collaborators = const [],
    this.page = 0,
    this.pageSize = defaultPageSize,
    this.totalElements = 0,
    this.searchQuery = '',
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.failure,
  });

  @override
  List<Object?> get props => [
    collaborators,
    page,
    pageSize,
    totalElements,
    searchQuery,
    isLoading,
    isLoadingDetail,
    failure,
  ];

  ManagerCollaboratorsState copyWith({
    List<ManagerCollaborator>? collaborators,
    int? page,
    int? pageSize,
    int? totalElements,
    String? searchQuery,
    bool? isLoading,
    bool? isLoadingDetail,
    ValueGetter<String?>? failure,
  }) {
    return ManagerCollaboratorsState(
      collaborators: collaborators ?? this.collaborators,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
