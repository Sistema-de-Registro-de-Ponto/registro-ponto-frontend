import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_dto.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

void main() {
  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  test('fromJson mapeia jornada e planned_activities', () {
    final dto = JourneyDto.fromJson({
      'id': 10,
      'collaborator_id': 4,
      'started_at': '2026-05-15T08:03:00-03:00',
      'planned_activities': [
        {
          'id': 1,
          'planned_activity_id': 7,
          'description': 'Ajustar API de login',
          'checked': true,
        },
        {
          'id': 2,
          'planned_activity_id': 8,
          'description': 'Reunião daily',
          'checked': false,
        },
      ],
      'status': 'in_progress',
      'created_at': '2026-05-15T08:03:01-03:00',
      'updated_at': '2026-05-15T08:03:01-03:00',
    });

    expect(dto.id, 10);
    expect(dto.collaboratorId, 4);
    expect(dto.startedAt, startedAt);
    expect(dto.status, JourneyStatus.inProgress);
    expect(dto.createdAt, createdAt);
    expect(dto.updatedAt, updatedAt);
    expect(dto.plannedActivities, hasLength(2));
    expect(dto.plannedActivities.first.id, 1);
    expect(dto.plannedActivities.first.plannedActivityId, 7);
    expect(dto.plannedActivities.first.description, 'Ajustar API de login');
    expect(dto.plannedActivities.first.checked, isTrue);
    expect(dto.plannedActivities.last.checked, isFalse);

    final entity = dto.toEntity();
    expect(entity.startedHourLabel, '08:03');
    expect(entity.plannedActivities.first.checked, isTrue);
  });
}
