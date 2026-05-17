import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/shared/app_check_list_item.dart';
import 'package:registro_ponto_frontend/shared/app_filled_button.dart';

class JourneyDetailDialog extends StatelessWidget {
  static const _adherenceHighThreshold = 80;
  static const _statusInProgressColor = Color(0xFF0284C7);
  static const _statusInProgressSurface = Color(0xFFE0F2FE);
  static const _statusCompletedColor = Color(0xFF16A34A);
  static const _statusCompletedSurface = Color(0xFFDCFCE7);
  static const _statusWaitingColor = Color(0xFF6B7280);
  static const _statusWaitingSurface = Color(0xFFF3F4F6);
  static const _adherenceHighColor = Color(0xFF16A34A);
  static const _adherenceLowColor = Color(0xFFEA580C);

  final Journey journey;
  final DateTime referenceTime;

  const JourneyDetailDialog({
    super.key,
    required this.journey,
    required this.referenceTime,
  });

  static Future<void> show(
    BuildContext context, {
    required Journey journey,
    required DateTime referenceTime,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => JourneyDetailDialog(
        journey: journey,
        referenceTime: referenceTime,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = journey.summary?.trim();

    return Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DialogHeader(journey: journey),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 24,
                  children: [
                    _OverviewSection(
                      journey: journey,
                      referenceTime: referenceTime,
                    ),
                    if (summary != null && summary.isNotEmpty)
                      _Section(
                        title: 'Resumo',
                        child: Text(
                          summary,
                          style: theme.textTheme.bodyLarge,
                        ),
                      ),
                    _PlannedActivitiesSection(journey: journey),
                    _UnplannedActivitiesSection(journey: journey),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: AppFilledButton(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Fechar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogHeader extends StatelessWidget {
  final Journey journey;

  const _DialogHeader({required this.journey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, surface) = _statusColors(journey.status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Detalhes da jornada',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${journey.historyDateLabel} · ${journey.historyWeekdayLabel}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    journey.historyStatusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            tooltip: 'Fechar',
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  (Color, Color) _statusColors(JourneyStatus status) => switch (status) {
    JourneyStatus.inProgress => (
      JourneyDetailDialog._statusInProgressColor,
      JourneyDetailDialog._statusInProgressSurface,
    ),
    JourneyStatus.completed => (
      JourneyDetailDialog._statusCompletedColor,
      JourneyDetailDialog._statusCompletedSurface,
    ),
    JourneyStatus.waiting => (
      JourneyDetailDialog._statusWaitingColor,
      JourneyDetailDialog._statusWaitingSurface,
    ),
  };
}

class _OverviewSection extends StatelessWidget {
  final Journey journey;
  final DateTime referenceTime;

  const _OverviewSection({
    required this.journey,
    required this.referenceTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adherence = journey.adherencePercent;
    final adherenceColor = adherence == null
        ? theme.colorScheme.onSurfaceVariant
        : (adherence >= JourneyDetailDialog._adherenceHighThreshold
              ? JourneyDetailDialog._adherenceHighColor
              : JourneyDetailDialog._adherenceLowColor);

    return _Section(
      title: 'Informações',
      child: Column(
        children: [
          _DetailRow(label: 'Entrada', value: journey.historyEntryLabel),
          _DetailRow(label: 'Saída', value: journey.historyExitLabel),
          _DetailRow(
            label: 'Total de horas',
            value: journey.historyTotalHoursLabel(referenceTime),
            valueStyle: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: journey.isHistoryInProgress ? FontWeight.w700 : null,
            ),
          ),
          _DetailRow(
            label: 'Aderência',
            value: journey.adherenceLabel,
            valueStyle: theme.textTheme.bodyMedium?.copyWith(
              color: adherenceColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlannedActivitiesSection extends StatelessWidget {
  final Journey journey;

  const _PlannedActivitiesSection({required this.journey});

  @override
  Widget build(BuildContext context) {
    final activities = journey.plannedActivities;

    return _Section(
      title: 'Atividades planejadas',
      child: activities.isEmpty
          ? const _EmptySectionMessage('Nenhuma atividade planejada registrada.')
          : Column(
              children: activities
                  .map(
                    (activity) => AppCheckListItem(
                      isChecked: activity.checked,
                      title: activity.description,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _UnplannedActivitiesSection extends StatelessWidget {
  final Journey journey;

  const _UnplannedActivitiesSection({required this.journey});

  @override
  Widget build(BuildContext context) {
    final activities = journey.unplannedActivities.toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return _Section(
      title: 'Atividades não planejadas',
      child: activities.isEmpty
          ? const _EmptySectionMessage('Nenhuma atividade não planejada registrada.')
          : Column(
              children: activities
                  .map(
                    (activity) => _UnplannedActivityRow(
                      description: activity.description,
                      timeLabel: activity.createdAt.formattedHourShort,
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 12,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        child,
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: valueStyle ?? theme.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnplannedActivityRow extends StatelessWidget {
  final String description;
  final String timeLabel;

  const _UnplannedActivityRow({
    required this.description,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            timeLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptySectionMessage extends StatelessWidget {
  final String message;

  const _EmptySectionMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
    );
  }
}
