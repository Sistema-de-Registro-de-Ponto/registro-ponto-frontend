import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_rpa_record.dart';

class ManagerRpaState extends Equatable {
  static const defaultPageSize = 10;

  final List<ManagerRpaRecord> records;
  final int page;
  final int pageSize;
  final int totalElements;
  final DateTime startDate;
  final DateTime endDate;
  final bool usesPeriodFilter;
  final String searchQuery;
  final bool isLoading;
  final String? failure;

  const ManagerRpaState({
    this.records = const [],
    this.page = 0,
    this.pageSize = defaultPageSize,
    this.totalElements = 0,
    required this.startDate,
    required this.endDate,
    this.usesPeriodFilter = false,
    this.searchQuery = '',
    this.isLoading = false,
    this.failure,
  });

  @override
  List<Object?> get props => [
    records,
    page,
    pageSize,
    totalElements,
    startDate,
    endDate,
    usesPeriodFilter,
    searchQuery,
    isLoading,
    failure,
  ];

  ManagerRpaState copyWith({
    List<ManagerRpaRecord>? records,
    int? page,
    int? pageSize,
    int? totalElements,
    DateTime? startDate,
    DateTime? endDate,
    bool? usesPeriodFilter,
    String? searchQuery,
    bool? isLoading,
    ValueGetter<String?>? failure,
  }) {
    return ManagerRpaState(
      records: records ?? this.records,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      usesPeriodFilter: usesPeriodFilter ?? this.usesPeriodFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
