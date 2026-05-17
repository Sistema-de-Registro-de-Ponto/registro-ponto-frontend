import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_item.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';

class ManagerSidebar extends StatelessWidget {
  static const width = 240.0;

  final ManagerNavDestination selected;
  final ValueChanged<ManagerNavDestination> onDestinationChanged;

  const ManagerSidebar({
    super.key,
    required this.selected,
    required this.onDestinationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: theme.colorScheme.outlineVariant)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SidebarHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final destination in ManagerNavDestination.mainDestinations)
                    ManagerNavItem(
                      label: destination.label,
                      icon: destination.icon,
                      selectedIcon: destination.selectedIcon,
                      selected: selected == destination,
                      onTap: () => onDestinationChanged(destination),
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            for (final destination in ManagerNavDestination.bottomDestinations)
              ManagerNavItem(
                label: destination.label,
                icon: destination.icon,
                selectedIcon: destination.selectedIcon,
                selected: selected == destination,
                onTap: () => onDestinationChanged(destination),
              ),
          ],
        ),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          const AppBrandLogo(compact: true, iconSize: 32, showTitle: false),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Área de Gestão',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
