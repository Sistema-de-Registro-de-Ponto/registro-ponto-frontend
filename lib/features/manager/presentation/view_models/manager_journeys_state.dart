import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_journey_list_item.dart';

class ManagerJourneysState extends Equatable {
  static const defaultPageSize = 10;

  final List<ManagerJourneyListItem> journeys;
  final int page;
  final int pageSize;
  final int totalElements;
  final DateTime startDate;
  final DateTime endDate;
  final bool usesPeriodFilter;
  final String collaboratorNameQuery;
  final bool isLoading;
  final bool isLoadingDetail;
  final String? failure;

  const ManagerJourneysState({
    this.journeys = const [],
    this.page = 0,
    this.pageSize = defaultPageSize,
    this.totalElements = 0,
    required this.startDate,
    required this.endDate,
    this.usesPeriodFilter = false,
    this.collaboratorNameQuery = '',
    this.isLoading = false,
    this.isLoadingDetail = false,
    this.failure,
  });

  @override
  List<Object?> get props => [
    journeys,
    page,
    pageSize,
    totalElements,
    startDate,
    endDate,
    usesPeriodFilter,
    collaboratorNameQuery,
    isLoading,
    isLoadingDetail,
    failure,
  ];

  ManagerJourneysState copyWith({
    List<ManagerJourneyListItem>? journeys,
    int? page,
    int? pageSize,
    int? totalElements,
    DateTime? startDate,
    DateTime? endDate,
    bool? usesPeriodFilter,
    String? collaboratorNameQuery,
    bool? isLoading,
    bool? isLoadingDetail,
    ValueGetter<String?>? failure,
  }) {
    return ManagerJourneysState(
      journeys: journeys ?? this.journeys,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      totalElements: totalElements ?? this.totalElements,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      usesPeriodFilter: usesPeriodFilter ?? this.usesPeriodFilter,
      collaboratorNameQuery:
          collaboratorNameQuery ?? this.collaboratorNameQuery,
      isLoading: isLoading ?? this.isLoading,
      isLoadingDetail: isLoadingDetail ?? this.isLoadingDetail,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
