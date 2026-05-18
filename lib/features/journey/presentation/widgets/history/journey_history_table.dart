import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_adherence_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_header_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_status_badge.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_text_cell.dart';

import 'journey_detail_dialog.dart';

class JourneyHistoryTable extends StatelessWidget {
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
                6: FixedColumnWidth(48),
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
      children: const [
        AppDataTableHeaderCell('DATA'),
        AppDataTableHeaderCell('ENTRADA'),
        AppDataTableHeaderCell('SAÍDA'),
        AppDataTableHeaderCell('TOTAL DE HORAS'),
        AppDataTableHeaderCell('ADERÊNCIA', textAlign: TextAlign.center),
        AppDataTableHeaderCell('STATUS', textAlign: TextAlign.center),
        SizedBox.shrink(),
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
        AppDataTableTextCell(journey.historyEntryLabel),
        AppDataTableTextCell(journey.historyExitLabel),
        _TotalHoursCell(journey: journey, referenceTime: referenceTime),
        AppDataTableAdherenceCell(
          label: journey.adherenceLabel,
          percent: journey.adherencePercent,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: journey.isHistoryInProgress
              ? AppDataTableStatusBadge.inProgress(journey.historyStatusLabel)
              : AppDataTableStatusBadge.completed(journey.historyStatusLabel),
        ),
        _ViewDetailsCell(journey: journey, referenceTime: referenceTime),
      ],
    );
  }
}

class _ViewDetailsCell extends StatelessWidget {
  final Journey journey;
  final DateTime referenceTime;

  const _ViewDetailsCell({
    required this.journey,
    required this.referenceTime,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: () => JourneyDetailDialog.show(
          context,
          journey: journey,
          referenceTime: referenceTime,
        ),
        tooltip: 'Ver detalhes',
        icon: const Icon(Icons.visibility_outlined),
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
