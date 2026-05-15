import 'package:flutter/material.dart';

class AppPendingActivityItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isEnabled;
  final VoidCallback onDelete;

  const AppPendingActivityItem({
    super.key,
    required this.title,
    required this.description,
    this.isEnabled = true,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(
              Icons.circle,
              size: 8,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: isEnabled ? onDelete : null,
            icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
            tooltip: 'Remover atividade',
          ),
        ],
      ),
    );
  }
}
