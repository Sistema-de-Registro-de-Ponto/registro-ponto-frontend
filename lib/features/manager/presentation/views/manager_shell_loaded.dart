import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_profile.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/views/manager_collaborators_body.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/views/manager_journeys_body.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/views/manager_overview_body.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/views/manager_reports_body.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/views/manager_rpa_body.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_sidebar.dart';
import 'package:registro_ponto_frontend/shared/app_developing.dart';
import 'package:registro_ponto_frontend/shared/app_profile_menu.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class ManagerShellLoaded extends ConsumerStatefulWidget {
  final ManagerProfile profile;

  const ManagerShellLoaded({super.key, required this.profile});

  @override
  ConsumerState<ManagerShellLoaded> createState() => _ManagerShellLoadedState();
}

class _ManagerShellLoadedState extends ConsumerState<ManagerShellLoaded> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  ManagerNavDestination _selected = ManagerNavDestination.overview;
  bool _sidebarVisible = true;

  ManagerProfile get profile => widget.profile;

  void _onDestinationChanged(ManagerNavDestination destination) {
    setState(() => _selected = destination);
    final scaffoldState = _scaffoldKey.currentState;
    if (scaffoldState?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }

  void _toggleModalDrawer() {
    final scaffoldState = _scaffoldKey.currentState;
    if (scaffoldState == null) return;
    if (scaffoldState.isDrawerOpen) {
      Navigator.of(context).pop();
      return;
    }
    scaffoldState.openDrawer();
  }

  void _togglePersistentSidebar() {
    setState(() => _sidebarVisible = !_sidebarVisible);
  }

  ManagerSidebar _buildSidebar() {
    return ManagerSidebar(
      selected: _selected,
      onDestinationChanged: _onDestinationChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.surfaceContainerLowest;

    return AppResponsive(
      mobile: Scaffold(
        key: _scaffoldKey,
        backgroundColor: backgroundColor,
        drawer: Drawer(width: ManagerSidebar.width, child: _buildSidebar()),
        body: _MainArea(
          profile: profile,
          selected: _selected,
          onMenuTap: _toggleModalDrawer,
        ),
      ),
      desktop: Scaffold(
        backgroundColor: backgroundColor,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_sidebarVisible) _buildSidebar(),
            Expanded(
              child: _MainArea(
                profile: profile,
                selected: _selected,
                onMenuTap: _togglePersistentSidebar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MainArea extends ConsumerWidget {
  final ManagerProfile profile;
  final ManagerNavDestination selected;
  final VoidCallback onMenuTap;

  const _MainArea({
    required this.profile,
    required this.selected,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          color: theme.colorScheme.surface,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: theme.colorScheme.outlineVariant),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: onMenuTap,
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: 'Menu',
                ),
                const Spacer(),
                AppProfileMenu(
                  firstName: profile.firstName,
                  avatarInitial: profile.firstLetterOfName,
                  roleLabel: 'Gestor',
                ),
              ],
            ),
          ),
        ),
        Expanded(child: _DestinationBody(destination: selected)),
      ],
    );
  }
}

class _DestinationBody extends StatelessWidget {
  final ManagerNavDestination destination;

  const _DestinationBody({required this.destination});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: Constants.desktopBreakpoint),
      child: switch (destination) {
        ManagerNavDestination.overview => const ManagerOverviewBody(),
        ManagerNavDestination.collaborators => const ManagerCollaboratorsBody(),
        ManagerNavDestination.journeys => const ManagerJourneysBody(),
        ManagerNavDestination.reports => const ManagerReportsBody(),
        ManagerNavDestination.rpa => const ManagerRpaBody(),
        _ => const AppDeveloping(),
      },
    );
  }
}
