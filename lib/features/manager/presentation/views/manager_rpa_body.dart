import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_rpa_view_model.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_page_header.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/rpa/manager_rpa_table.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_error_banner.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';
import 'package:registro_ponto_frontend/shared/app_period_field.dart';
import 'package:registro_ponto_frontend/shared/app_text_form_field.dart';
import 'package:registro_ponto_frontend/shared/data_table/app_data_table_pagination.dart';

class ManagerRpaBody extends ConsumerStatefulWidget {
  const ManagerRpaBody({super.key});

  @override
  ConsumerState<ManagerRpaBody> createState() => _ManagerRpaBodyState();
}

class _ManagerRpaBodyState extends ConsumerState<ManagerRpaBody> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(managerRpaViewModelProvider.notifier).loadRecords();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(managerRpaViewModelProvider);
    final notifier = ref.read(managerRpaViewModelProvider.notifier);
    final theme = Theme.of(context);

    if (state.isLoading && state.records.isEmpty) {
      return const Center(child: AppLoading());
    }

    if (state.failure != null && state.records.isEmpty) {
      return Center(
        child: AppError(
          state.failure ?? 'Não foi possível carregar os registros RPA.',
          onRetry: notifier.loadRecords,
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
                  destination: ManagerNavDestination.rpa,
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
                Text(
                  'Batidas importadas do portal externo pelo robô Python. '
                  'São independentes das jornadas registradas no app.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
                        ManagerRpaTable(records: state.records),
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
