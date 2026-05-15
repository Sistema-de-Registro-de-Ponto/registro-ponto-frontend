import 'dart:async';

import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';

class AppElapsedTime extends StatefulWidget {
  final String title;
  final bool canBegin;
  final DateTime? startedAt;

  const AppElapsedTime({
    super.key,
    this.title = 'Tempo decorrido',
    required this.canBegin,
    this.startedAt,
  });

  @override
  State<AppElapsedTime> createState() => _AppElapsedTimeState();
}

class _AppElapsedTimeState extends State<AppElapsedTime> {
  Timer? _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _syncTimer();
  }

  @override
  void didUpdateWidget(covariant AppElapsedTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.canBegin != widget.canBegin ||
        oldWidget.startedAt != widget.startedAt) {
      _syncTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(maxWidth: 280),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4,
        children: [
          Text(
            widget.title,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              mainAxisSize: MainAxisSize.min,
              spacing: 4,
              children: [
                Text(
                  _elapsedLabel,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    fontSize: 42,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                Text(
                  'horas',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _elapsedLabel {
    if (!widget.canBegin || widget.startedAt == null) return '--:--:--';

    return _now.elapsedSince(widget.startedAt!).formattedHms;
  }

  void _syncTimer() {
    _timer?.cancel();
    _now = DateTime.now();

    if (!widget.canBegin || widget.startedAt == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _now = DateTime.now());
    });
  }
}
