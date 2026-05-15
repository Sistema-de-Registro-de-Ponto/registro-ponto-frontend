import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/shared/app_elapsed_time.dart';

import 'app_filled_button.dart';

enum AppJourneyStatus {
  waiting,
  inProgress,
  completed;

  String get headline {
    return switch (this) {
      AppJourneyStatus.waiting => 'JORNADA PRONTA PARA INICIAR',
      AppJourneyStatus.inProgress => 'JORNADA EM ANDAMENTO',
      AppJourneyStatus.completed => 'JORNADA CONCLUÍDA',
    };
  }

  String get badgeLabel {
    return switch (this) {
      AppJourneyStatus.waiting => 'AGUARDANDO',
      AppJourneyStatus.inProgress => 'EM ANDAMENTO',
      AppJourneyStatus.completed => 'CONCLUÍDA',
    };
  }

  Color get accentColor {
    return switch (this) {
      AppJourneyStatus.waiting => const Color(0xFF0284C7),
      AppJourneyStatus.inProgress => const Color(0xFF16A34A),
      AppJourneyStatus.completed => const Color(0xFF6B7280),
    };
  }

  Color get badgeSurfaceColor {
    return switch (this) {
      AppJourneyStatus.waiting => const Color(0xFFE0F2FE),
      AppJourneyStatus.inProgress => const Color(0xFFDCFCE7),
      AppJourneyStatus.completed => const Color(0xFFF3F4F6),
    };
  }
}

class AppJourney extends StatelessWidget {
  final AppJourneyStatus status;
  final String? startedHour;
  final DateTime? startedAt;
  final VoidCallback? onEndJourney;
  final bool isEndingJourney;
  final bool isLoading;
  final bool canStartJourney;
  final VoidCallback? onStartJourney;

  const AppJourney({
    super.key,
    this.isLoading = false,
    required this.status,
    this.startedHour,
    this.startedAt,
    this.onEndJourney,
    this.isEndingJourney = false,
    this.canStartJourney = false,
    this.onStartJourney,
  });

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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: 30,
          children: [
            _JourneyHeader(status: status, startedHour: startedHour),
            if (status == AppJourneyStatus.inProgress) ...[
              Center(
                child: AppElapsedTime(
                  canBegin: status == AppJourneyStatus.inProgress,
                  startedAt: startedAt,
                ),
              ),
              AppFilledButton(
                text: 'ENCERRAR JORNADA',
                icon: Icons.stop,
                onPressed: onEndJourney,
                isLoading: isEndingJourney,
                isEnabled: onEndJourney != null,
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ],
            if (status == AppJourneyStatus.waiting) ...[
              AppFilledButton(
                text: 'INICIAR JORNADA',
                icon: Icons.play_arrow,
                onPressed: onStartJourney,
                isLoading: isLoading,
                isEnabled: canStartJourney,
              ),
              Row(
                spacing: 4,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  Flexible(
                    child: Text(
                      'O horário de entrada será registrado automaticamente.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _JourneyHeader extends StatelessWidget {
  final AppJourneyStatus status;
  final String? startedHour;

  const _JourneyHeader({required this.status, this.startedHour});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 8,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 6,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Icon(Icons.circle, size: 10, color: status.accentColor),
                      Expanded(
                        child: Text(
                          status.headline,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (startedHour case final hour?)
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Text(
                        'Iniciada às $hour',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _StatusBadge(status: status),
          ],
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final AppJourneyStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.badgeSurfaceColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.badgeLabel,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: status.accentColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
