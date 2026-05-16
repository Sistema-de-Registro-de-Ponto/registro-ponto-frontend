import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';

class JourneyHistoryTable extends StatelessWidget {
  static const _adherenceHighThreshold = 80;

  static const _statusInProgressColor = Color(0xFF0284C7);
  static const _statusInProgressSurface = Color(0xFFE0F2FE);
  static const _statusCompletedColor = Color(0xFF16A34A);
  static const _statusCompletedSurface = Color(0xFFDCFCE7);
  static const _adherenceHighColor = Color(0xFF16A34A);
  static const _adherenceLowColor = Color(0xFFEA580C);

  final List<Journey> journeys;
  final DateTime referenceTime;

  const JourneyHistoryTable({
    super.key,
    required this.journeys,
    required this.referenceTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (journeys.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'Nenhuma jornada encontrada no período.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: constraints.maxWidth),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.5),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1.2),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1.2),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _headerRow(theme),
                ...journeys.map((journey) => _dataRow(theme, journey)),
              ],
            ),
          ),
        );
      },
    );
  }

  TableRow _headerRow(ThemeData theme) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      children: [
        _HeaderCell('DATA'),
        _HeaderCell('ENTRADA'),
        _HeaderCell('SAÍDA'),
        _HeaderCell('TOTAL DE HORAS'),
        _HeaderCell('ADERÊNCIA', textAlign: TextAlign.center),
        _HeaderCell('STATUS', textAlign: TextAlign.center),
      ],
    );
  }

  TableRow _dataRow(ThemeData theme, Journey journey) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      children: [
        _DateCell(journey: journey),
        _TextCell(journey.historyEntryLabel),
        _TextCell(journey.historyExitLabel),
        _TotalHoursCell(journey: journey, referenceTime: referenceTime),
        _AdherenceCell(
          label: journey.adherenceLabel,
          percent: journey.adherencePercent,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: _StatusBadge(
            label: journey.historyStatusLabel,
            isInProgress: journey.isHistoryInProgress,
          ),
        ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final TextAlign textAlign;

  const _HeaderCell(this.label, {this.textAlign = TextAlign.start});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Text(
        label,
        textAlign: textAlign,
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  final Journey journey;

  const _DateCell({required this.journey});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            journey.historyDateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            journey.historyWeekdayLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextCell extends StatelessWidget {
  final String value;

  const _TextCell(this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(value),
    );
  }
}

class _TotalHoursCell extends StatelessWidget {
  final Journey journey;
  final DateTime referenceTime;

  const _TotalHoursCell({required this.journey, required this.referenceTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hoursLabel = journey.historyTotalHoursLabel(referenceTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            hoursLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: journey.isHistoryInProgress
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
          if (journey.isHistoryInProgress)
            Text(
              'Em andamento',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _AdherenceCell extends StatelessWidget {
  final String label;
  final int? percent;

  const _AdherenceCell({required this.label, required this.percent});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adherence = percent;
    final color = adherence == null
        ? theme.colorScheme.onSurfaceVariant
        : (adherence >= JourneyHistoryTable._adherenceHighThreshold
              ? JourneyHistoryTable._adherenceHighColor
              : JourneyHistoryTable._adherenceLowColor);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final bool isInProgress;

  const _StatusBadge({required this.label, required this.isInProgress});

  @override
  Widget build(BuildContext context) {
    final color = isInProgress
        ? JourneyHistoryTable._statusInProgressColor
        : JourneyHistoryTable._statusCompletedColor;
    final surface = isInProgress
        ? JourneyHistoryTable._statusInProgressSurface
        : JourneyHistoryTable._statusCompletedSurface;

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
