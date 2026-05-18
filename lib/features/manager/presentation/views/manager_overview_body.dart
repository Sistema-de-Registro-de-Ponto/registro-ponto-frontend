import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_overview_view_model.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_overview_metrics_row.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

class ManagerOverviewBody extends ConsumerStatefulWidget {
  const ManagerOverviewBody({super.key});

  @override
  ConsumerState<ManagerOverviewBody> createState() => _ManagerOverviewBodyState();
}

class _ManagerOverviewBodyState extends ConsumerState<ManagerOverviewBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managerOverviewViewModelProvider.notifier).loadOverview();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerOverviewViewModelProvider);
    final notifier = ref.read(managerOverviewViewModelProvider.notifier);

    if (state.isLoading && state.overview == null) {
      return const Center(child: AppLoading());
    }

    if (state.failure != null && state.overview == null) {
      return Center(
        child: AppError(
          state.failure ?? 'Não foi possível carregar a visão geral.',
          onRetry: notifier.loadOverview,
        ),
      );
    }

    final overview = state.overview;
    if (overview == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Constants.desktopBreakpoint),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                if (state.failure case final failure?)
                  AppErrorBanner(message: failure),
                if (state.isLoading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: AppLoading(dimension: 24, strokeWidth: 2),
                  ),
                ManagerOverviewMetricsRow(overview: overview),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
