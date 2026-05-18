import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/shared/app_period_field.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class ManagerPageHeader extends StatelessWidget {
  final ManagerNavDestination destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<DateTimeRange>? onPeriodChanged;

  const ManagerPageHeader({
    super.key,
    required this.destination,
    this.startDate,
    this.endDate,
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final periodField = _buildPeriodField();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: AppResponsive(
        desktopBreakpoint: 600,
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            _TitleBlock(destination: destination),
            ?periodField,
          ],
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.desktopBreakpoint),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _TitleBlock(destination: destination)),
                ?periodField,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildPeriodField() {
    if (!destination.showDateFilters) return null;

    final start = startDate;
    final end = endDate;
    final onChanged = onPeriodChanged;
    if (start == null || end == null || onChanged == null) return null;

    return AppPeriodField(
      startDate: start,
      endDate: end,
      onPeriodChanged: onChanged,
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final ManagerNavDestination destination;

  const _TitleBlock({required this.destination});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          destination.pageTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          destination.pageSubtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
