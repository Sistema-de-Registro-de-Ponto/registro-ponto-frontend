import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_history_view_model.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/history/journey_history_card.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

class JourneyHistoryBody extends ConsumerStatefulWidget {
  const JourneyHistoryBody({super.key});

  @override
  ConsumerState<JourneyHistoryBody> createState() => _JourneyHistoryBodyState();
}

class _JourneyHistoryBodyState extends ConsumerState<JourneyHistoryBody> {
  Timer? _timer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _syncElapsedTimer(bool shouldTick) {
    if (shouldTick && _timer == null) {
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _now = DateTime.now());
      });
      return;
    }

    if (!shouldTick && _timer != null) {
      _timer?.cancel();
      _timer = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journeyHistoryViewModelProvider);
    final notifier = ref.read(journeyHistoryViewModelProvider.notifier);

    _syncElapsedTimer(state.hasInProgressJourney);

    if (state.isLoading && state.journeys.isEmpty) {
      return const Center(child: AppLoading());
    }

    if (state.failure != null && state.journeys.isEmpty) {
      return Center(
        child: AppError(
          state.failure ?? 'Não foi possível carregar o histórico.',
          onRetry: () => notifier.loadJourneys(),
        ),
      );
    }

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Constants.desktopBreakpoint,
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                if (state.failure case final failure?)
                  AppErrorBanner(message: failure),
                JourneyHistoryCard(
                  startDate: state.startDate,
                  endDate: state.endDate,
                  onPeriodChanged: notifier.changePeriod,
                  journeys: state.journeys,
                  referenceTime: _now,
                  hasMore: state.hasMore,
                  isLoadingMore: state.isLoadingMore,
                  onLoadMore: () => notifier.loadJourneys(loadMore: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
