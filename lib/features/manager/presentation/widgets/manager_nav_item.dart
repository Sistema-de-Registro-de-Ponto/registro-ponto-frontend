import 'package:flutter/material.dart';

class ManagerNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  const ManagerNavItem({
    super.key,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foregroundColor = selected ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;

    return Material(
      color: selected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.45) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: selected ? theme.colorScheme.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Icon(selected ? selectedIcon : icon, size: 22, color: foregroundColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: foregroundColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
