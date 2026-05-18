import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_collaborator.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_adherence_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_header_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_text_cell.dart';

class ManagerReportsTable extends StatelessWidget {
  final List<ManagerConsolidatedReportCollaborator> collaborators;

  const ManagerReportsTable({super.key, required this.collaborators});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (collaborators.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Center(
          child: Text(
            'Nenhum colaborador encontrado.',
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
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
                5: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                _headerRow(theme),
                ...collaborators.map((item) => _dataRow(theme, item)),
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
        AppDataTableHeaderCell('COLABORADOR'),
        AppDataTableHeaderCell('HORAS', textAlign: TextAlign.center),
        AppDataTableHeaderCell('PLANEJADAS', textAlign: TextAlign.center),
        AppDataTableHeaderCell('CONCLUÍDAS', textAlign: TextAlign.center),
        AppDataTableHeaderCell('NÃO PLANEJ.', textAlign: TextAlign.center),
        AppDataTableHeaderCell('ADERÊNCIA', textAlign: TextAlign.center),
      ],
    );
  }

  TableRow _dataRow(
    ThemeData theme,
    ManagerConsolidatedReportCollaborator collaborator,
  ) {
    return TableRow(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      children: [
        AppDataTableTextCell(
          collaborator.firstName,
          fontWeight: FontWeight.w700,
        ),
        AppDataTableTextCell(
          collaborator.durationLabel,
          textAlign: TextAlign.center,
        ),
        AppDataTableTextCell(
          '${collaborator.plannedActivities}',
          textAlign: TextAlign.center,
        ),
        AppDataTableTextCell(
          '${collaborator.activitiesCompleted}',
          textAlign: TextAlign.center,
        ),
        AppDataTableTextCell(
          '${collaborator.unplannedActivities}',
          textAlign: TextAlign.center,
        ),
        AppDataTableAdherenceCell(
          label: collaborator.adherenceLabel,
          percent: collaborator.adherencePercentage,
        ),
      ],
    );
  }
}
