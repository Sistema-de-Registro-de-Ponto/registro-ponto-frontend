import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_inform_activity.dart';
import 'package:registro_ponto_frontend/shared/app_pending_activity_item.dart';

import '../view_models/activity_state.dart';
import '../view_models/activity_view_model.dart';

class PlannedActivitiesSection extends ConsumerStatefulWidget {
  const PlannedActivitiesSection({super.key});

  @override
  ConsumerState<PlannedActivitiesSection> createState() =>
      _PlannedActivitiesSectionState();
}

class _PlannedActivitiesSectionState
    extends ConsumerState<PlannedActivitiesSection> {
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(activityViewModelProvider);
    final viewModel = ref.read(activityViewModelProvider.notifier);
    final theme = Theme.of(context);

    ref.listen(activityViewModelProvider, (previous, next) {
      if (previous?.description != next.description &&
          next.description.isEmpty) {
        _descriptionController.clear();
      }
    });

    return Column(
      spacing: 16,
      children: [
        if (state.failure case final failure?) AppErrorBanner(message: failure),
        AppInformActivity(
          title: 'Adicionar atividade planejada',
          hintText: 'Descreva a atividade...',
          descriptionController: _descriptionController,
          descriptionErrorText: state.descriptionErrorText,
          isSubmitting: state.isLoading,
          onDescriptionChanged: viewModel.setDescription,
          onSubmitted: viewModel.submitPlannedActivity,
          children: _activityListChildren(state, viewModel, theme),
        ),
      ],
    );
  }

  List<Widget>? _activityListChildren(
    ActivityState state,
    ActivityViewModel viewModel,
    ThemeData theme,
  ) {
    if (state.activities.isEmpty) return null;

    return [
      Text(
        'Atividades planejadas',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      ...state.activities.map(
        (item) => AppPendingActivityItem(
          isEnabled: !state.isLoading,
          title: item.description,
          description: item.timeLabel,
          onDelete: () => viewModel.deletePlannedActivity(item.id),
        ),
      ),
    ];
  }
}
