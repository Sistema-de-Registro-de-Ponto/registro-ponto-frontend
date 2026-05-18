import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_overview.dart';

class ManagerOverviewState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final ManagerOverview? overview;
  final bool isLoading;
  final String? failure;

  const ManagerOverviewState({
    required this.startDate,
    required this.endDate,
    this.overview,
    this.isLoading = false,
    this.failure,
  });

  @override
  List<Object?> get props => [startDate, endDate, overview, isLoading, failure];

  ManagerOverviewState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    ValueGetter<ManagerOverview?>? overview,
    bool? isLoading,
    ValueGetter<String?>? failure,
  }) {
    return ManagerOverviewState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      overview: overview != null ? overview() : this.overview,
      isLoading: isLoading ?? this.isLoading,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
