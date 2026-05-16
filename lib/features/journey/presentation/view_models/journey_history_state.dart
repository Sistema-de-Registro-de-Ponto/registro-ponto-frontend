import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';

class JourneyHistoryState extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final List<Journey> journeys;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int nextPage;
  final String? failure;

  const JourneyHistoryState({
    required this.startDate,
    required this.endDate,
    this.journeys = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.nextPage = 0,
    this.failure,
  });

  bool get hasInProgressJourney =>
      journeys.any((journey) => journey.isHistoryInProgress);

  @override
  List<Object?> get props => [
    startDate,
    endDate,
    journeys,
    isLoading,
    isLoadingMore,
    hasMore,
    nextPage,
    failure,
  ];

  JourneyHistoryState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    ValueGetter<List<Journey>>? journeys,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? nextPage,
    ValueGetter<String?>? failure,
  }) {
    return JourneyHistoryState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      journeys: journeys != null ? journeys() : this.journeys,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      nextPage: nextPage ?? this.nextPage,
      failure: failure != null ? failure() : this.failure,
    );
  }
}
