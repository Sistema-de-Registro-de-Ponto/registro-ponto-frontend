import 'package:equatable/equatable.dart';
import 'package:registro_ponto_frontend/core/pagination/page.dart';

import 'manager_consolidated_report_collaborator.dart';
import 'manager_consolidated_report_summary.dart';

class ManagerConsolidatedReport extends Equatable {
  final DateTime startDate;
  final DateTime endDate;
  final ManagerConsolidatedReportSummary summary;
  final Page<ManagerConsolidatedReportCollaborator> collaborators;

  const ManagerConsolidatedReport({
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.collaborators,
  });

  @override
  List<Object?> get props => [startDate, endDate, summary, collaborators];
}
