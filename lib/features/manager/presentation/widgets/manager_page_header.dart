import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/shared/app_period_field.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class ManagerPageHeader extends StatelessWidget {
  final ManagerNavDestination destination;

  const ManagerPageHeader({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: AppResponsive(
        desktopBreakpoint: 600,
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            _TitleBlock(destination: destination),
            if (destination.showDateFilters)
              AppPeriodField(
                startDate: today,
                endDate: today,
                onPeriodChanged: (period) {}, // TODO: Implement period change
              ),
          ],
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.desktopBreakpoint),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _TitleBlock(destination: destination)),
                if (destination.showDateFilters)
                  AppPeriodField(
                    startDate: today,
                    endDate: today,
                    onPeriodChanged:
                        (period) {}, // TODO: Implement period change
                  ),
              ],
            ),
          ),
        ),
      ),
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
