import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/core/pagination/page_dto.dart';

import '../../domain/entities/manager_consolidated_report.dart';
import 'manager_consolidated_report_collaborator_dto.dart';
import 'manager_consolidated_report_summary_dto.dart';

class ManagerConsolidatedReportDto {
  final DateTime startDate;
  final DateTime endDate;
  final ManagerConsolidatedReportSummaryDto summary;
  final PageDto<ManagerConsolidatedReportCollaboratorDto> collaborators;

  const ManagerConsolidatedReportDto({
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.collaborators,
  });

  factory ManagerConsolidatedReportDto.fromJson(Map<String, dynamic> json) {
    final period = json['period'] as Map<String, dynamic>;

    return ManagerConsolidatedReportDto(
      startDate: DateTime.parse(period['start_date'] as String).dateOnly,
      endDate: DateTime.parse(period['end_date'] as String).dateOnly,
      summary: ManagerConsolidatedReportSummaryDto.fromJson(
        json['summary'] as Map<String, dynamic>,
      ),
      collaborators: PageDto.fromJson(
        json['collaborators'] as Map<String, dynamic>,
        ManagerConsolidatedReportCollaboratorDto.fromJson,
      ),
    );
  }

  ManagerConsolidatedReport toEntity() {
    return ManagerConsolidatedReport(
      startDate: startDate,
      endDate: endDate,
      summary: summary.toEntity(),
      collaborators: collaborators.toEntity((item) => item.toEntity()),
    );
  }
}
