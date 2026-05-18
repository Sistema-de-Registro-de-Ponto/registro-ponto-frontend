import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator_detail.dart';
import 'package:registro_ponto_frontend/shared/app_filled_button.dart';

class ManagerCollaboratorSummaryDialog extends StatelessWidget {
  final ManagerCollaboratorDetail detail;

  const ManagerCollaboratorSummaryDialog({super.key, required this.detail});

  static Future<void> show(
    BuildContext context, {
    required ManagerCollaboratorDetail detail,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) => ManagerCollaboratorSummaryDialog(detail: detail),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              Text(
                detail.firstName,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Este colaborador não possui jornada em andamento no momento.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              _SummaryRow(label: 'Horas (hoje)', value: detail.hoursTodayLabel),
              _SummaryRow(label: 'Aderência', value: detail.adherenceLabel),
              AppFilledButton(
                onPressed: () => Navigator.of(context).pop(),
                text: 'Fechar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
