import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/collaborator/presentation/widgets/nav_entry.dart';

class NavTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const NavTabs({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        NavEntry(
          label: 'Dashboard',
          icon: Icons.home_outlined,
          selectedIcon: Icons.home_rounded,
          selected: index == 0,
          color: theme.colorScheme.primary,
          onTap: () => onChanged(0),
        ),
        NavEntry(
          label: 'Histórico',
          icon: Icons.history_rounded,
          selectedIcon: Icons.history_rounded,
          selected: index == 1,
          color: theme.colorScheme.primary,
          onTap: () => onChanged(1),
        ),
        NavEntry(
          label: 'Perfil',
          icon: Icons.person_outline_rounded,
          selectedIcon: Icons.person_rounded,
          selected: index == 2,
          color: theme.colorScheme.primary,
          onTap: () => onChanged(2),
        ),
      ],
    );
  }
}
