import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_collaborator_detail_dto.dart';

void main() {
  test('mapeia detalhe com jornada atual', () {
    final dto = ManagerCollaboratorDetailDto.fromJson(<String, dynamic>{
      'id': 1,
      'user_id': 10,
      'first_name': 'Maria',
      'hours_today_seconds': 8100,
      'adherence_percentage': 95,
      'current_journey': <String, dynamic>{
        'id': 42,
        'collaborator_id': 1,
        'started_at': '2026-05-18T08:00:00-03:00',
        'journey_planned_activities': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 101,
            'planned_activity_id': 5,
            'description': 'Revisar relatórios contábeis',
            'is_checked': true,
          },
        ],
        'unplanned_activities': <Map<String, dynamic>>[],
        'status': 'in_progress',
        'created_at': '2026-05-18T08:00:00-03:00',
        'updated_at': '2026-05-18T10:15:00-03:00',
      },
    });

    expect(dto.userId, 10);
    expect(dto.currentJourney?.id, 42);
    expect(dto.currentJourney?.status, JourneyStatus.inProgress);

    final entity = dto.toEntity();
    expect(entity.currentJourney?.id, 42);
    expect(entity.currentJourney?.plannedActivities, hasLength(1));
  });
}
