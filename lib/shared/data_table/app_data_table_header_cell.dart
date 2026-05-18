import 'package:flutter/material.dart';

class AppDataTableHeaderCell extends StatelessWidget {
  final String label;
  final TextAlign textAlign;

  const AppDataTableHeaderCell(
    this.label, {
    super.key,
    this.textAlign = TextAlign.start,
  });

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
