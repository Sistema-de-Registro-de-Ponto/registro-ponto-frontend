import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

import '../../../../../shared/app_period_field.dart';

class JourneyHistoryHeader extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final ValueChanged<DateTimeRange> onPeriodChanged;

  const JourneyHistoryHeader({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppResponsive(
      desktopBreakpoint: 600,
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 16,
        children: [
          _TitleBlock(theme: theme),
          AppPeriodField(
            startDate: startDate,
            endDate: endDate,
            onPeriodChanged: onPeriodChanged,
          ),
        ],
      ),

      desktop: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _TitleBlock(theme: theme),
          AppPeriodField(
            startDate: startDate,
            endDate: endDate,
            onPeriodChanged: onPeriodChanged,
          ),
        ],
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final ThemeData theme;

  const _TitleBlock({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4,
      children: [
        Text(
          'Histórico de Jornadas',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Acompanhe todas as suas jornadas registradas.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
