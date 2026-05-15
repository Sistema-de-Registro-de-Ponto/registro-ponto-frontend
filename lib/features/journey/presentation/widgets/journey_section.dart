import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/shared/app_check_list.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_journey.dart';

import '../view_models/journey_view_model.dart';

class JourneySection extends ConsumerWidget {
  const JourneySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(journeyViewModelProvider);
    final viewModel = ref.read(journeyViewModelProvider.notifier);
    final journey = state.journey;

    return Column(
      spacing: 16,
      children: [
        if (state.failure case final failure?) AppErrorBanner(message: failure),
        AppJourney(
          status: state.uiStatus,
          startedHour: journey?.startedHourLabel,
          startedAt: journey?.startedAt,
          isLoading: state.isLoading,
          canStartJourney: state.canStartJourney,
          onStartJourney: viewModel.startJourney,
        ),
        if (state.showPlannedActivitiesChecklist)
          AppCheckList(
            title: 'Atividades planejadas para hoje',
            items: state.checklistItems,
          ),
      ],
    );
  }
}
