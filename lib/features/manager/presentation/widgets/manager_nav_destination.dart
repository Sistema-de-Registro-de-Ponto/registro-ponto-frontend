import 'package:flutter/material.dart';

enum ManagerNavDestination {
  overview(
    label: 'Visão Geral',
    pageTitle: 'Visão Geral',
    pageSubtitle: 'Acompanhe os principais indicadores da operação',
    icon: Icons.grid_view_rounded,
    selectedIcon: Icons.grid_view_rounded,
    showDateFilters: true,
  ),
  collaborators(
    label: 'Colaboradores',
    pageTitle: 'Colaboradores',
    pageSubtitle: 'Visualize e consulte os colaboradores cadastrados',
    icon: Icons.groups_outlined,
    selectedIcon: Icons.groups_rounded,
  ),
  journeys(
    label: 'Jornadas',
    pageTitle: 'Jornadas',
    pageSubtitle: 'Consulte e acompanhe as jornadas registradas.',
    icon: Icons.schedule_outlined,
    selectedIcon: Icons.schedule_rounded,
  ),
  reports(
    label: 'Relatórios',
    pageTitle: 'Relatórios',
    pageSubtitle: 'Indicadores e exportações',
    icon: Icons.assessment_outlined,
    selectedIcon: Icons.assessment_rounded,
  ),
  rpa(
    label: 'RPA',
    pageTitle: 'RPA',
    pageSubtitle: 'Registros importados do portal externo',
    icon: Icons.smart_toy_outlined,
    selectedIcon: Icons.smart_toy_rounded,
  ),
  settings(
    label: 'Configurações',
    pageTitle: 'Configurações',
    pageSubtitle: 'Preferências da área de gestão',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
    isBottom: true,
  );

  const ManagerNavDestination({
    required this.label,
    required this.pageTitle,
    required this.pageSubtitle,
    required this.icon,
    required this.selectedIcon,
    this.showDateFilters = false,
    this.isBottom = false,
  });

  final String label;
  final String pageTitle;
  final String pageSubtitle;
  final IconData icon;
  final IconData selectedIcon;
  final bool showDateFilters;
  final bool isBottom;

  static const mainDestinations = [
    ManagerNavDestination.overview,
    ManagerNavDestination.collaborators,
    ManagerNavDestination.journeys,
    ManagerNavDestination.reports,
    ManagerNavDestination.rpa,
  ];

  static const bottomDestinations = [ManagerNavDestination.settings];
}
