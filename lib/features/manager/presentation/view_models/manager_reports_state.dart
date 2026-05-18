import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_collaborator.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_summary.dart';

class ManagerReportsState extends Equatable {
  static const defaultPageSize = 10;

  final DateTime startDate;
  final DateTime endDate;
  final ManagerConsolidatedReportSummary? summary;
  final List<ManagerConsolidatedReportCollaborator> collaborators;
  final int page;
  final int pageSize;
  final int totalElements;
  final String searchQuery;
  final bool isLoading;
  final String? failure;

  const ManagerReportsState({
    required this.startDate,
    required this.endDate,
    this.summary,
    this.collaborators = const [],
    this.page = 0,
    this.pageSize = defaultPageSize,
    this.totalElements = 0,
    this.searchQuery = '',
    this.isLoading = false,
    this.failure,
  });

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    summary,
    collaborators,
    page,
    pageSize,
    totalElements,
    searchQuery,
    isLoading,
    failure,
  ];

  ManagerReportsState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    ValueGetter<ManagerConsolidatedReportSummary?>? summary,
    List<ManagerConsolidatedReportCollaborator>? collaborators,
    int? page,
    int? pageSize,
    int? totalElements,
    String? searchQuery,
    bool? isLoading,
    ValueGetter<String?>? failure,
  }) {
    return ManagerReportsState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      summary: summary != null ? summary() : this.summary,
      collaborators: collaborators ?? this.collaborators,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
