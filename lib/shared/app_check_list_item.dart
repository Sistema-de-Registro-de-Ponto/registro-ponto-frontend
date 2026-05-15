import 'package:flutter/material.dart';

class AppCheckListItem extends StatelessWidget {
  static const _completedGreen = Color(0xFF16A34A);
  static const _completedGreenSurface = Color(0xFFDCFCE7);

  final bool isChecked;
  final String title;

  const AppCheckListItem({
    super.key,
    required this.isChecked,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _CheckIcon(isChecked: isChecked),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                decoration: isChecked ? TextDecoration.lineThrough : null,
                color: isChecked
                    ? theme.colorScheme.onSurfaceVariant
                    : theme.colorScheme.onSurface,
              ),
            ),
          ),
          if (isChecked) const _CompletedBadge(),
        ],
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool isChecked;

  const _CheckIcon({required this.isChecked});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isChecked) {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: AppCheckListItem._completedGreen,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.check, size: 16, color: Colors.white),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 2),
      ),
    );
  }
}

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppCheckListItem._completedGreenSurface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        'Concluída',
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppCheckListItem._completedGreen,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
