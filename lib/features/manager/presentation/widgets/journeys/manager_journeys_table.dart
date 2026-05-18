import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_journey_list_item.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_header_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_status_badge.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_text_cell.dart';

class ManagerJourneysTable extends StatelessWidget {
  final List<ManagerJourneyListItem> journeys;
  final DateTime referenceTime;
  final ValueChanged<ManagerJourneyListItem> onViewDetails;

  const ManagerJourneysTable({
    super.key,
    required this.journeys,
    required this.referenceTime,
    required this.onViewDetails,
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
                1: FlexColumnWidth(1.8),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1.2),
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
        AppDataTableHeaderCell('COLABORADOR'),
        AppDataTableHeaderCell('ENTRADA'),
        AppDataTableHeaderCell('SAÍDA'),
        AppDataTableHeaderCell('TOTAL DE HORAS'),
        AppDataTableHeaderCell('STATUS', textAlign: TextAlign.center),
        SizedBox.shrink(),
      ],
    );
  }

  TableRow _dataRow(ThemeData theme, ManagerJourneyListItem journey) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      children: [
        _DateCell(journey: journey),
        AppDataTableTextCell(journey.collaboratorFirstName),
        AppDataTableTextCell(journey.entryLabel),
        AppDataTableTextCell(journey.exitLabel),
        _TotalHoursCell(journey: journey, referenceTime: referenceTime),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: journey.isInProgress
              ? AppDataTableStatusBadge.inProgress(journey.statusLabel)
              : AppDataTableStatusBadge.completed(journey.statusLabel),
        ),
        _ViewDetailsCell(journey: journey, onViewDetails: onViewDetails),
      ],
    );
  }
}

class _ViewDetailsCell extends StatelessWidget {
  final ManagerJourneyListItem journey;
  final ValueChanged<ManagerJourneyListItem> onViewDetails;

  const _ViewDetailsCell({
    required this.journey,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: () => onViewDetails(journey),
        tooltip: 'Ver detalhes',
        icon: const Icon(Icons.visibility_outlined),
      ),
    );
  }
}

class _DateCell extends StatelessWidget {
  final ManagerJourneyListItem journey;

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
            journey.dateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            journey.weekdayLabel,
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
  final ManagerJourneyListItem journey;
  final DateTime referenceTime;

  const _TotalHoursCell({required this.journey, required this.referenceTime});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hoursLabel = journey.totalHoursLabel(referenceTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 2,
        children: [
          Text(
            hoursLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: journey.isInProgress
                  ? FontWeight.w700
                  : FontWeight.w400,
            ),
          ),
          if (journey.isInProgress)
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
