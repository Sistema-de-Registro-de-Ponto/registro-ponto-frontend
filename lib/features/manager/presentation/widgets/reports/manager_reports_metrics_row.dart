import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_consolidated_report_summary.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_overview_metric_card.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class ManagerReportsMetricsRow extends StatelessWidget {
  final ManagerConsolidatedReportSummary summary;

  const ManagerReportsMetricsRow({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return AppResponsive(
      desktopBreakpoint: 600,
      mobile: _MetricsList(summary: summary, axis: Axis.vertical),
      desktop: _MetricsList(summary: summary, axis: Axis.horizontal),
    );
  }
}

class _MetricsList extends StatelessWidget {
  final ManagerConsolidatedReportSummary summary;
  final Axis axis;

  const _MetricsList({required this.summary, required this.axis});

  @override
  Widget build(BuildContext context) {
    final cards = _buildCards();

    if (axis == Axis.vertical) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 12,
        children: cards,
      );
    }

    return Center(
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards
            .map(
              (card) => ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 195.2),
                child: card,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _buildCards() {
    final duration = Duration(seconds: summary.durationSeconds);

    return [
      ManagerOverviewMetricCard(
        icon: Icons.schedule_outlined,
        title: 'Total de horas',
        value: duration.formattedHm,
        subtitle: 'Período selecionado',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.event_note_outlined,
        title: 'Atividades planejadas',
        value: '${summary.plannedActivities}',
        subtitle: 'Total no período',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.task_alt_outlined,
        title: 'Atividades concluídas',
        value: '${summary.activitiesCompleted}',
        subtitle: 'Total no período',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.radio_button_unchecked_outlined,
        title: 'Não planejadas',
        value: '${summary.unplannedActivities}',
        subtitle: 'Total no período',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.track_changes_outlined,
        title: 'Aderência média',
        value: '${summary.averageAdherencePercentage}%',
        subtitle: 'No período selecionado',
      ),
    ];
  }
}
