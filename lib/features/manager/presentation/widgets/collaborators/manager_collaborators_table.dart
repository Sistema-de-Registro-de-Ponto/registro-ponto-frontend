import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_adherence_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_header_cell.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_status_badge.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_text_cell.dart';

class ManagerCollaboratorsTable extends StatelessWidget {
  final List<ManagerCollaborator> collaborators;
  final ValueChanged<ManagerCollaborator> onViewDetails;

  const ManagerCollaboratorsTable({
    super.key,
    required this.collaborators,
    required this.onViewDetails,
  });

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
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FixedColumnWidth(48),
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
        AppDataTableHeaderCell('NOME'),
        AppDataTableHeaderCell('JORNADA ATUAL', textAlign: TextAlign.center),
        AppDataTableHeaderCell('HORAS (HOJE)'),
        AppDataTableHeaderCell('ADERÊNCIA', textAlign: TextAlign.center),
        SizedBox.shrink(),
      ],
    );
  }

  TableRow _dataRow(ThemeData theme, ManagerCollaborator collaborator) {
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: collaborator.isCurrentJourneyInProgress
              ? AppDataTableStatusBadge.inProgress(
                  collaborator.currentJourneyStatusLabel,
                )
              : AppDataTableStatusBadge.completed(
                  collaborator.currentJourneyStatusLabel,
                ),
        ),
        AppDataTableTextCell(collaborator.hoursTodayLabel),
        AppDataTableAdherenceCell(
          label: collaborator.adherenceLabel,
          percent: collaborator.adherencePercentage,
        ),
        _ViewDetailsCell(
          collaborator: collaborator,
          onViewDetails: onViewDetails,
        ),
      ],
    );
  }
}

class _ViewDetailsCell extends StatelessWidget {
  final ManagerCollaborator collaborator;
  final ValueChanged<ManagerCollaborator> onViewDetails;

  const _ViewDetailsCell({
    required this.collaborator,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: IconButton(
        onPressed: () => onViewDetails(collaborator),
        tooltip: 'Ver detalhes',
        icon: const Icon(Icons.visibility_outlined),
      ),
    );
  }
}
