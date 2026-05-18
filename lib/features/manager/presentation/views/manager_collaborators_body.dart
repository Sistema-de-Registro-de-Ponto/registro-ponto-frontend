import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/history/journey_detail_dialog.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_collaborators_state.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_collaborators_view_model.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/collaborators/manager_collaborator_summary_dialog.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/collaborators/manager_collaborators_table.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_page_header.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_pagination.dart';

class ManagerCollaboratorsBody extends ConsumerStatefulWidget {
  const ManagerCollaboratorsBody({super.key});

  @override
  ConsumerState<ManagerCollaboratorsBody> createState() =>
      _ManagerCollaboratorsBodyState();
}

class _ManagerCollaboratorsBodyState
    extends ConsumerState<ManagerCollaboratorsBody> {
  final _searchController = TextEditingController();
  Timer? _elapsedTimer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(managerCollaboratorsViewModelProvider.notifier)
          .loadCollaborators();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _elapsedTimer?.cancel();
    super.dispose();
  }

  void _syncElapsedTimer(bool shouldTick) {
    if (shouldTick && _elapsedTimer == null) {
      _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() => _now = DateTime.now());
      });
      return;
    }

    if (!shouldTick && _elapsedTimer != null) {
      _elapsedTimer?.cancel();
      _elapsedTimer = null;
    }
  }

  bool _hasInProgressJourney(ManagerCollaboratorsState state) {
    return state.collaborators.any((item) => item.isCurrentJourneyInProgress);
  }

  Future<void> _onViewDetails(ManagerCollaborator collaborator) async {
    final notifier = ref.read(managerCollaboratorsViewModelProvider.notifier);
    final detail = await notifier.loadCollaboratorDetail(collaborator.id);

    if (!mounted || detail == null) return;

    final journey = detail.currentJourney;
    if (journey != null) {
      await JourneyDetailDialog.show(
        context,
        journey: journey,
        referenceTime: _now,
      );
      return;
    }

    await ManagerCollaboratorSummaryDialog.show(context, detail: detail);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerCollaboratorsViewModelProvider);
    final notifier = ref.read(managerCollaboratorsViewModelProvider.notifier);
    final theme = Theme.of(context);

    _syncElapsedTimer(_hasInProgressJourney(state));

    if (state.isLoading && state.collaborators.isEmpty) {
      return const Center(child: AppLoading());
    }

    if (state.failure != null && state.collaborators.isEmpty) {
      return Center(
        child: AppError(
          state.failure ?? 'Não foi possível carregar os colaboradores.',
          onRetry: notifier.loadCollaborators,
        ),
      );
    }

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 16,
            children: [
              ManagerPageHeader(
                destination: ManagerNavDestination.collaborators,
                suffix: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: AppTextFormField(
                    controller: _searchController,

                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Buscar colaborador...',
                    textInputAction: TextInputAction.search,
                    onChanged: notifier.onSearchChanged,
                    enabled: true,
                  ),
                ),
              ),
              if (state.failure case final failure?)
                AppErrorBanner(message: failure),

              Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.outlineVariant),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(bottom: 16),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: AppLoading(dimension: 24, strokeWidth: 2),
                          ),
                        ),
                      ManagerCollaboratorsTable(
                        collaborators: state.collaborators,
                        onViewDetails: _onViewDetails,
                      ),
                      AppDataTablePagination(
                        page: state.page,
                        pageSize: state.pageSize,
                        totalElements: state.totalElements,
                        onPageChanged: notifier.changePage,
                        onPageSizeChanged: notifier.changePageSize,
                      ),
                    ],
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
