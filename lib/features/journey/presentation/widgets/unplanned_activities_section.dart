import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/shared/app_inform_activity.dart';
import 'package:registro_ponto_frontend/shared/app_pending_activity_item.dart';

import '../view_models/journey_state.dart';
import '../view_models/journey_view_model.dart';

class UnplannedActivitiesSection extends ConsumerStatefulWidget {
  const UnplannedActivitiesSection({super.key});

  @override
  ConsumerState<UnplannedActivitiesSection> createState() =>
      _UnplannedActivitiesSectionState();
}

class _UnplannedActivitiesSectionState
    extends ConsumerState<UnplannedActivitiesSection> {
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(journeyViewModelProvider);
    if (!state.showUnplannedActivitiesPanel) return const SizedBox.shrink();

    final viewModel = ref.read(journeyViewModelProvider.notifier);
    final theme = Theme.of(context);
    final interactionEnabled = state.isJourneyInProgress;

    ref.listen(journeyViewModelProvider, (previous, next) {
      if (previous?.unplannedDescription != next.unplannedDescription &&
          next.unplannedDescription.isEmpty) {
        _descriptionController.clear();
      }
    });

    return AppInformActivity(
      title: 'Adicionar atividade não planejada',
      hintText: 'Descreva a atividade...',
      descriptionController: _descriptionController,
      descriptionErrorText: state.unplannedDescriptionErrorText,
      isSubmitting: state.isUnplannedMutationBusy,
      interactionEnabled: interactionEnabled,
      onDescriptionChanged: viewModel.setUnplannedDescription,
      onSubmitted: viewModel.submitUnplannedActivity,
      children: _activityListChildren(
        state,
        viewModel,
        theme,
        interactionEnabled,
      ),
    );
  }

  List<Widget>? _activityListChildren(
    JourneyState state,
    JourneyViewModel viewModel,
    ThemeData theme,
    bool interactionEnabled,
  ) {
    final items = state.journey?.unplannedActivities.toList() ?? const [];
    if (items.isEmpty) return null;

    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return [
      Text(
        'Atividades não planejadas',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      ...items.map(
        (item) => AppPendingActivityItem(
          isEnabled: interactionEnabled && !state.isUnplannedMutationBusy,
          title: item.description,
          description: item.createdAt.formattedHourShort,
          onDelete: () => viewModel.deleteUnplannedActivity(item.id),
        ),
      ),
    ];
  }
}
