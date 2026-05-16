import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/shared/app_check_list.dart';
import 'package:registro_ponto_frontend/shared/app_confirm_dialog.dart';
import 'package:registro_ponto_frontend/shared/app_journey.dart';

import '../view_models/journey_view_model.dart';
import 'journey_summary_dialog.dart';

class JourneySection extends ConsumerStatefulWidget {
  const JourneySection({super.key});

  @override
  ConsumerState<JourneySection> createState() => _JourneySectionState();
}

class _JourneySectionState extends ConsumerState<JourneySection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(journeyViewModelProvider.notifier).loadInProgressJourney();
    });
  }

  Future<void> _onStartJourneyPressed() async {
    final confirmed =
        await AppConfirmDialog.show(
          context,
          title: 'Iniciar jornada?',
          message:
              'O horário de entrada será registrado automaticamente. Deseja continuar?',
          confirmLabel: 'Iniciar',
        ) ??
        false;
    if (!confirmed || !mounted) return;

    await ref.read(journeyViewModelProvider.notifier).startJourney();
  }

  Future<void> _onEndJourneyPressed() async {
    final confirmed =
        await AppConfirmDialog.show(
          context,
          title: 'Encerrar jornada?',
          message:
              'As atividades planejadas e não planejadas serão registradas. '
              'Após encerrar, não será possível alterar a jornada.',
          confirmLabel: 'Continuar',
          isDestructive: true,
        ) ??
        false;
    if (!confirmed || !mounted) return;

    final summary = await JourneySummaryDialog.show(context);
    if (summary == null || !mounted) return;

    final success =
        await ref.read(journeyViewModelProvider.notifier).endJourney(summary);
    if (!success || !mounted) return;

    await AppConfirmDialog.showAcknowledgement(
      context,
      title: 'Jornada encerrada',
      message: 'Sua jornada foi finalizada com sucesso.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journeyViewModelProvider);
    final viewModel = ref.read(journeyViewModelProvider.notifier);
    final journey = state.journey;

    return Column(
      spacing: 16,
      children: [
        AppJourney(
          status: state.uiStatus,
          startedHour: journey?.startedHourLabel,
          startedAt: journey?.startedAt,
          isLoading: state.isLoading,
          canStartJourney: state.canStartJourney,
          onStartJourney: state.canStartJourney ? _onStartJourneyPressed : null,
          onEndJourney: state.canEndJourney ? _onEndJourneyPressed : null,
          isEndingJourney: state.isEndingJourney,
        ),
        if (state.showJourneyPlannedChecklist)
          AppCheckList(
            title: 'Atividades planejadas para hoje',
            items: state.buildChecklistItems(
              allowToggle: state.isJourneyInProgress,
              onSetChecked: viewModel.setChecked,
            ),
          ),
      ],
    );
  }
}
