import 'package:flutter/material.dart';

import 'app_data_table_style.dart';

class AppDataTableAdherenceCell extends StatelessWidget {
  final String label;
  final int? percent;

  const AppDataTableAdherenceCell({
    super.key,
    required this.label,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final adherence = percent;
    final color = adherence == null
        ? theme.colorScheme.onSurfaceVariant
        : (adherence >= AppDataTableStyle.adherenceHighThreshold
              ? AppDataTableStyle.adherenceHighColor
              : AppDataTableStyle.adherenceLowColor);

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
