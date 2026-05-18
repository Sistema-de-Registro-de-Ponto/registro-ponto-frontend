import 'package:flutter/material.dart';

import 'app_data_table_style.dart';

class AppDataTableStatusBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const AppDataTableStatusBadge({
    super.key,
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  factory AppDataTableStatusBadge.inProgress(String label) {
    return AppDataTableStatusBadge(
      label: label,
      foregroundColor: AppDataTableStyle.statusInProgressColor,
      backgroundColor: AppDataTableStyle.statusInProgressSurface,
    );
  }

  factory AppDataTableStatusBadge.completed(String label) {
    return AppDataTableStatusBadge(
      label: label,
      foregroundColor: AppDataTableStyle.statusCompletedColor,
      backgroundColor: AppDataTableStyle.statusCompletedSurface,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: foregroundColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
