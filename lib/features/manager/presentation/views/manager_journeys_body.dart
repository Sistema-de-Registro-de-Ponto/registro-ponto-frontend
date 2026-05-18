import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/history/journey_detail_dialog.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_journey_list_item.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_journeys_state.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_journeys_view_model.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/journeys/manager_journeys_table.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_page_header.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';
import 'package:registro_ponto_frontend/shared/app_period_field.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_pagination.dart';

class ManagerJourneysBody extends ConsumerStatefulWidget {
  const ManagerJourneysBody({super.key});

  @override
  ConsumerState<ManagerJourneysBody> createState() =>
      _ManagerJourneysBodyState();
}

class _ManagerJourneysBodyState extends ConsumerState<ManagerJourneysBody> {
  final _collaboratorNameController = TextEditingController();
  Timer? _elapsedTimer;
  late DateTime _now;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managerJourneysViewModelProvider.notifier).loadJourneys();
    });
  }

  @override
  void dispose() {
    _collaboratorNameController.dispose();
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

  bool _hasInProgressJourney(ManagerJourneysState state) {
    return state.journeys.any((item) => item.isInProgress);
  }

  Future<void> _onViewDetails(ManagerJourneyListItem item) async {
    final notifier = ref.read(managerJourneysViewModelProvider.notifier);
    final journey = await notifier.loadJourneyDetail(item.id);

    if (!mounted || journey == null) return;

    await JourneyDetailDialog.show(
      context,
      journey: journey,
      referenceTime: _now,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerJourneysViewModelProvider);
    final notifier = ref.read(managerJourneysViewModelProvider.notifier);
    final theme = Theme.of(context);

    _syncElapsedTimer(_hasInProgressJourney(state));

    if (state.isLoading && state.journeys.isEmpty) {
      return const Center(child: AppLoading());
    }

    if (state.failure != null && state.journeys.isEmpty) {
      return Center(
        child: AppError(
          state.failure ?? 'Não foi possível carregar as jornadas.',
          onRetry: notifier.loadJourneys,
        ),
      );
    }

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Constants.desktopBreakpoint,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                ManagerPageHeader(
                  destination: ManagerNavDestination.journeys,
                  suffix: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      AppPeriodField(
                        startDate: state.startDate,
                        endDate: state.endDate,
                        onPeriodChanged: notifier.changePeriod,
                      ),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 280),
                        child: AppTextFormField(
                          controller: _collaboratorNameController,
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Nome do colaborador...',
                          textInputAction: TextInputAction.search,
                          onChanged: notifier.onCollaboratorNameChanged,
                          enabled: !state.isLoadingDetail,
                        ),
                      ),
                    ],
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
                        ManagerJourneysTable(
                          journeys: state.journeys,
                          referenceTime: _now,
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
      ),
    );
  }
}
