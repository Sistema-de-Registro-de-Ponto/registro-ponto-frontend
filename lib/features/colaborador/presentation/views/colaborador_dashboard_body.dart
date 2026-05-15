import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

import '../../domain/entities/colaborador_profile.dart';

class ColaboradorDashboardBody extends StatefulWidget {
  final ColaboradorProfile profile;

  const ColaboradorDashboardBody({super.key, required this.profile});

  @override
  State<ColaboradorDashboardBody> createState() => _ColaboradorDashboardBodyState();
}

class _ColaboradorDashboardBodyState extends State<ColaboradorDashboardBody> {
  Timer? _timer;
  late DateTime _now;

  ColaboradorProfile get profile => widget.profile;

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
    return LayoutBuilder(
      builder: (_, constraints) {
        if (constraints.maxWidth < 640) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _GreetingBlock(now: _now, profile: profile),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: _ClockCard(now: _now),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _GreetingBlock(now: _now, profile: profile),
              _ClockCard(now: _now),
            ],
          ),
        );
      },
    );
  }
}

class _GreetingBlock extends StatelessWidget {
  final DateTime now;
  final ColaboradorProfile profile;

  const _GreetingBlock({required this.now, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${now.formattedGreeting}, ${profile.firstName}! 👋',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(
          now.formattedLongDate,
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
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
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
