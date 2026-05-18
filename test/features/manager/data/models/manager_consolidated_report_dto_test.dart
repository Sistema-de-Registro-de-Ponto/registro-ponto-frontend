import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_consolidated_report_dto.dart';

void main() {
  test('fromJson mapeia período, summary e colaboradores paginados', () {
    const json = <String, dynamic>{
      'period': <String, dynamic>{
        'start_date': '2026-05-01',
        'end_date': '2026-05-18',
      },
      'summary': <String, dynamic>{
        'duration_seconds': 45000,
        'planned_activities': 42,
        'activities_completed': 30,
        'unplanned_activities': 8,
        'average_adherence_percentage': 71,
      },
      'collaborators': <String, dynamic>{
        'content': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 1,
            'first_name': 'Natanael',
            'duration_seconds': 12600,
            'planned_activities': 10,
            'activities_completed': 7,
            'unplanned_activities': 2,
            'adherence_percentage': 70,
          },
        ],
        'number': 0,
        'size': 10,
        'totalElements': 1,
        'first': true,
        'last': true,
        'empty': false,
      },
    };

    final dto = ManagerConsolidatedReportDto.fromJson(json);
    final entity = dto.toEntity();

    expect(entity.summary.durationSeconds, 45000);
    expect(entity.summary.plannedActivities, 42);
    expect(entity.collaborators.content.single.firstName, 'Natanael');
    expect(entity.collaborators.content.single.adherencePercentage, 70);
    expect(entity.collaborators.totalElements, 1);
  });
}
