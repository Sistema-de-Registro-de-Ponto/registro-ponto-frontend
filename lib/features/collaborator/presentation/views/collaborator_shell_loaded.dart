import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/features/collaborator/domain/entities/collaborator_profile.dart';
import 'package:registro_ponto_frontend/features/collaborator/presentation/views/collaborator_dashboard_body.dart';
import 'package:registro_ponto_frontend/features/collaborator/presentation/widgets/nav_tabs.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';
import 'package:registro_ponto_frontend/shared/app_developing.dart';
import 'package:registro_ponto_frontend/shared/app_profile_menu.dart';

class CollaboratorShellLoaded extends ConsumerStatefulWidget {
  final CollaboratorProfile profile;

  const CollaboratorShellLoaded({super.key, required this.profile});

  @override
  ConsumerState<CollaboratorShellLoaded> createState() => _CollaboratorShellLoadedState();
}

class _CollaboratorShellLoadedState extends ConsumerState<CollaboratorShellLoaded> {
  int _tabIndex = 0;

  CollaboratorProfile get profile => widget.profile;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: theme.colorScheme.surface,
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: LayoutBuilder(
                builder: (_, constraints) {
                  if (constraints.maxWidth < 720) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Align(alignment: Alignment.centerLeft, child: AppBrandLogo(compact: true)),
                        const SizedBox(height: 12),
                        NavTabs(index: _tabIndex, onChanged: (i) => setState(() => _tabIndex = i)),
                        const SizedBox(height: 12),
                        AppProfileMenu(profile: profile),
                      ],
                    );
                  }
                  return Row(
                    children: [
                      const AppBrandLogo(compact: true),
                      Expanded(
                        child: Center(
                          child: NavTabs(index: _tabIndex, onChanged: (i) => setState(() => _tabIndex = i)),
                        ),
                      ),
                      AppProfileMenu(profile: profile),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                CollaboratorDashboardBody(profile: profile),
                const AppDeveloping(),
                const AppDeveloping(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
