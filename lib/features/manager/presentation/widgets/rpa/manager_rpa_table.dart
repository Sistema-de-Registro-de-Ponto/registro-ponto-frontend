import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_rpa_record.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_header_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_text_cell.dart';

class ManagerRpaTable extends StatelessWidget {
  final List<ManagerRpaRecord> records;

  const ManagerRpaTable({super.key, required this.records});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (records.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'Nenhum registro importado no período.',
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
                0: FlexColumnWidth(1.2),
                1: FlexColumnWidth(1.6),
                2: FlexColumnWidth(0.9),
                3: FlexColumnWidth(0.9),
                4: FlexColumnWidth(0.9),
                5: FlexColumnWidth(1),
                6: FlexColumnWidth(1),
                7: FlexColumnWidth(1.4),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _headerRow(theme),
                ...records.map((record) => _dataRow(theme, record)),
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
        AppDataTableHeaderCell('MATRÍCULA'),
        AppDataTableHeaderCell('ENTRADA'),
        AppDataTableHeaderCell('SAÍDA'),
        AppDataTableHeaderCell('HORAS'),
        AppDataTableHeaderCell('ORIGEM'),
        AppDataTableHeaderCell('IMPORTADO EM'),
      ],
    );
  }

  TableRow _dataRow(ThemeData theme, ManagerRpaRecord record) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      children: [
        _DateCell(record: record),
        AppDataTableTextCell(record.employeeDisplayName),
        AppDataTableTextCell(record.externalEmployeeId),
        AppDataTableTextCell(record.entryLabel),
        AppDataTableTextCell(record.exitLabel),
        AppDataTableTextCell(record.workedHoursLabel),
        AppDataTableTextCell(record.sourceSystemLabel),
        AppDataTableTextCell(record.importedAtLabel),
      ],
    );
  }
}

class _DateCell extends StatelessWidget {
  final ManagerRpaRecord record;

  const _DateCell({required this.record});

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
            record.dateLabel,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            record.weekdayLabel,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
