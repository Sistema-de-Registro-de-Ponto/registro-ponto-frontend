import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

class AppCheckListItem extends StatelessWidget {
  static const _completedGreen = Color(0xFF16A34A);
  static const _completedGreenSurface = Color(0xFFDCFCE7);

  final bool isChecked;
  final String title;
  final VoidCallback? onTap;
  final bool isBusy;

  const AppCheckListItem({
    super.key,
    required this.isChecked,
    required this.title,
    this.onTap,
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        children: [
          _CheckIcon(isChecked: isChecked, showBusy: isBusy),
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

    if (onTap == null) return Opacity(opacity: isBusy ? 0.55 : 1, child: row);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isBusy ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(opacity: isBusy ? 0.55 : 1, child: row),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  final bool isChecked;
  final bool showBusy;

  const _CheckIcon({required this.isChecked, this.showBusy = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (showBusy) {
      return SizedBox.square(
        dimension: 22,
        child: Center(child: AppLoading(dimension: 18)),
      );
    }

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
