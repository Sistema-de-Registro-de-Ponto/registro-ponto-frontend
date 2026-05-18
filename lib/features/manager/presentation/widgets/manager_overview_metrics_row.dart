import 'package:flutter/material.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_overview.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/widgets/manager_overview_metric_card.dart';
import 'package:registro_ponto_frontend/shared/app_responsive.dart';

class ManagerOverviewMetricsRow extends StatelessWidget {
  final ManagerOverview overview;

  const ManagerOverviewMetricsRow({super.key, required this.overview});

  @override
  Widget build(BuildContext context) {
    return AppResponsive(
      desktopBreakpoint: 600,
      mobile: _MetricsList(overview: overview, axis: Axis.vertical),
      desktop: _MetricsList(overview: overview, axis: Axis.horizontal),
    );
  }
}

class _MetricsList extends StatelessWidget {
  final ManagerOverview overview;
  final Axis axis;

  const _MetricsList({required this.overview, required this.axis});

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
                constraints: const BoxConstraints(maxWidth: 250),
                child: card,
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _buildCards() {
    final duration = Duration(seconds: overview.durationSeconds);

    return [
      ManagerOverviewMetricCard(
        icon: Icons.schedule_outlined,
        title: 'Total de horas',
        value: duration.formattedHm,
        subtitle: 'Período selecionado',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.play_circle_outline_rounded,
        title: 'Jornadas em andamento',
        value: '${overview.journeysInProgress}',
        subtitle: 'Colaboradores ativos',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.track_changes_outlined,
        title: 'Aderência média',
        value: '${overview.averageAdherencePercentage}%',
        subtitle: 'No período selecionado',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.task_alt_outlined,
        title: 'Atividades concluídas',
        value: '${overview.activitiesCompleted}',
        subtitle: 'Total de atividades',
      ),
      ManagerOverviewMetricCard(
        icon: Icons.radio_button_unchecked_outlined,
        title: 'Não planejadas',
        value: '${overview.unplannedActivities}',
        subtitle: 'Total de atividades',
      ),
    ];
  }
}
