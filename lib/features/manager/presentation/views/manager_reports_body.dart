import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_reports_view_model.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_page_header.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/reports/manager_reports_metrics_row.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/reports/manager_reports_table.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';
import 'package:registro_ponto_frontend/shared/app_period_field.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_pagination.dart';

class ManagerReportsBody extends ConsumerStatefulWidget {
  const ManagerReportsBody({super.key});

  @override
  ConsumerState<ManagerReportsBody> createState() => _ManagerReportsBodyState();
}

class _ManagerReportsBodyState extends ConsumerState<ManagerReportsBody> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managerReportsViewModelProvider.notifier).loadReport();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerReportsViewModelProvider);
    final notifier = ref.read(managerReportsViewModelProvider.notifier);
    final theme = Theme.of(context);

    if (state.isLoading && state.summary == null) {
      return const Center(child: AppLoading());
    }

    if (state.failure != null && state.summary == null) {
      return Center(
        child: AppError(
          state.failure ?? 'Não foi possível carregar os relatórios.',
          onRetry: notifier.loadReport,
        ),
      );
    }

    final summary = state.summary;
    if (summary == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: Constants.desktopBreakpoint,
          ),
          child: Padding(
            padding: EdgeInsets.zero,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 16,
              children: [
                ManagerPageHeader(
                  destination: ManagerNavDestination.reports,
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
                          controller: _searchController,
                          prefixIcon: const Icon(Icons.search),
                          hintText: 'Nome do colaborador...',
                          textInputAction: TextInputAction.search,
                          onChanged: notifier.onSearchChanged,
                          enabled: !state.isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.failure case final failure?)
                  AppErrorBanner(message: failure),
                if (state.isLoading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: AppLoading(dimension: 24, strokeWidth: 2),
                  ),
                ManagerReportsMetricsRow(summary: summary),
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
                        ManagerReportsTable(collaborators: state.collaborators),
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
