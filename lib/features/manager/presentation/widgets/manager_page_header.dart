import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_nav_destination.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class ManagerPageHeader extends StatelessWidget {
  final ManagerNavDestination destination;
  final Widget? suffix;

  const ManagerPageHeader({super.key, required this.destination, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 4, right: 4, bottom: 16),
      child: AppResponsive(
        desktopBreakpoint: 600,
        mobile: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 16,
          children: [
            _TitleBlock(destination: destination),
            ?suffix,
          ],
        ),
        desktop: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: Constants.desktopBreakpoint),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _TitleBlock(destination: destination)),
                ?suffix,
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
