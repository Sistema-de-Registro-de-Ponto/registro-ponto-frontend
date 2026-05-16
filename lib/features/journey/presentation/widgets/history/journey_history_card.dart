import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';

import 'journey_history_header.dart';
import 'journey_history_load_more_button.dart';
import 'journey_history_table.dart';

class JourneyHistoryCard extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTimeRange> onPeriodChanged;
  final List<Journey> journeys;
  final DateTime referenceTime;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback? onLoadMore;

  const JourneyHistoryCard({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onPeriodChanged,
    required this.journeys,
    required this.referenceTime,
    required this.hasMore,
    this.isLoadingMore = false,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 24,
      children: [
        JourneyHistoryHeader(
          startDate: startDate,
          endDate: endDate,
          onPeriodChanged: onPeriodChanged,
        ),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                JourneyHistoryTable(
                  journeys: journeys,
                  referenceTime: referenceTime,
                ),
                if (hasMore)
                  JourneyHistoryLoadMoreButton(
                    onPressed: onLoadMore,
                    isLoading: isLoadingMore,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
