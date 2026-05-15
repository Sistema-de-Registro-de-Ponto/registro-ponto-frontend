import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/core/utils/constants.dart';
import 'package:registro_ponto_frontend/features/activity/presentation/widgets/planned_activities_section.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/journey_section.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

import '../../domain/entities/collaborator_profile.dart';

class CollaboratorDashboardBody extends StatefulWidget {
  final CollaboratorProfile profile;

  const CollaboratorDashboardBody({super.key, required this.profile});

  @override
  State<CollaboratorDashboardBody> createState() =>
      _CollaboratorDashboardBodyState();
}

class _CollaboratorDashboardBodyState extends State<CollaboratorDashboardBody> {
  Timer? _timer;
  late DateTime _now;

  CollaboratorProfile get profile => widget.profile;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: Constants.desktopBreakpoint,
        ),
        child: AppResponsive(
          mobile: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  _GreetingBlock(now: _now, profile: profile),
                  _ClockCard(now: _now),
                  const JourneySection(),
                  const PlannedActivitiesSection(),
                ],
              ),
            ),
          ),
          desktop: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: 24,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Center(
                        child: _GreetingBlock(now: _now, profile: profile),
                      ),
                      Center(child: _ClockCard(now: _now)),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Flexible(child: const JourneySection()),
                      Flexible(child: const PlannedActivitiesSection()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  final DateTime now;
  final CollaboratorProfile profile;

  const _GreetingBlock({required this.now, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${now.formattedGreeting}, ${profile.firstName}! 👋',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          now.formattedLongDate,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _ClockCard extends StatelessWidget {
  final DateTime now;

  const _ClockCard({required this.now});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              now.formattedHour,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Horário atual',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
