import 'package:flutter/material.dart';

import 'app_check_list_item.dart';

class AppCheckList extends StatelessWidget {
  final String title;
  final List<AppCheckListItem> items;

  const AppCheckList({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...items,
            ],
          ],
        ),
      ),
    );
  }
}
