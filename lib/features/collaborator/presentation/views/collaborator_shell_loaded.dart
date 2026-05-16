import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/features/collaborator/domain/entities/collaborator_profile.dart';
import 'package:registro_ponto_frontend/features/collaborator/presentation/views/collaborator_dashboard_body.dart';
import 'package:registro_ponto_frontend/features/collaborator/presentation/widgets/nav_tabs.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_history_view_model.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/views/journey_history_body.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';
import 'package:registro_ponto_frontend/shared/app_developing.dart';
import 'package:registro_ponto_frontend/shared/app_profile_menu.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class CollaboratorShellLoaded extends ConsumerStatefulWidget {
  final CollaboratorProfile profile;

  const CollaboratorShellLoaded({super.key, required this.profile});

  @override
  ConsumerState<CollaboratorShellLoaded> createState() => _CollaboratorShellLoadedState();
}

class _CollaboratorShellLoadedState extends ConsumerState<CollaboratorShellLoaded> {
  static const _historyTabIndex = 1;

  int _tabIndex = 0;

  CollaboratorProfile get profile => widget.profile;

  void _onTabChanged(int index) {
    setState(() => _tabIndex = index);

    if (index == _historyTabIndex) {
      ref.read(journeyHistoryViewModelProvider.notifier).loadJourneys();
    }
  }

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
              child: AppResponsive(
                mobile: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 16,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        AppBrandLogo(compact: true),
                        const Spacer(),
                        AppProfileMenu(profile: profile),
                      ],
                    ),
                    NavTabs(index: _tabIndex, onChanged: _onTabChanged),
                  ],
                ),
                desktop: Row(
                  children: [
                    const AppBrandLogo(compact: true),
                    Expanded(
                      child: Center(
                        child: NavTabs(index: _tabIndex, onChanged: _onTabChanged),
                      ),
                    ),
                    AppProfileMenu(profile: profile),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                CollaboratorDashboardBody(profile: profile),
                const JourneyHistoryBody(),
                const AppDeveloping(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
