import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/core/extensions/datetime_extensions.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_dto.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

void main() {
  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  test('fromJson mapeia jornada e journey_planned_activities', () {
    final dto = JourneyDto.fromJson({
      'id': 10,
      'collaborator_id': 4,
      'started_at': '2026-05-15T08:03:00-03:00',
      'journey_planned_activities': [
        {
          'id': 1,
          'planned_activity_id': 7,
          'description': 'Ajustar API de login',
          'is_checked': true,
        },
        {
          'id': 2,
          'planned_activity_id': 8,
          'description': 'Reunião daily',
          'is_checked': false,
        },
      ],
      'status': 'in_progress',
      'created_at': '2026-05-15T08:03:01-03:00',
      'updated_at': '2026-05-15T08:03:01-03:00',
    });

    expect(dto.unplannedActivities, isEmpty);

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
    expect(entity.startedHourLabel, startedAt.formattedHourShort);
    expect(entity.plannedActivities.first.checked, isTrue);
  });

  test('fromJson mapeia unplanned_activities', () {
    final unplannedCreatedAt = DateTime.parse('2026-05-15T09:15:00-03:00').toLocal();

    final dto = JourneyDto.fromJson({
      'id': 10,
      'collaborator_id': 4,
      'started_at': '2026-05-15T08:03:00-03:00',
      'journey_planned_activities': <Map<String, dynamic>>[],
      'unplanned_activities': [
        {
          'id': 5,
          'journey_id': 10,
          'description': 'Ajuste em regra de permissão',
          'created_at': '2026-05-15T09:15:00-03:00',
        },
      ],
      'status': 'in_progress',
      'created_at': '2026-05-15T08:03:01-03:00',
      'updated_at': '2026-05-15T08:03:01-03:00',
    });

    expect(dto.unplannedActivities, hasLength(1));
    expect(dto.unplannedActivities.single.id, 5);
    expect(dto.unplannedActivities.single.journeyId, 10);
    expect(dto.unplannedActivities.single.description, 'Ajuste em regra de permissão');

    final entity = dto.toEntity();
    expect(
      entity.unplannedActivities.single.createdAt.formattedHourShort,
      unplannedCreatedAt.formattedHourShort,
    );
  });

  test('fromJson mapeia ended_at, duration_seconds e summary quando presentes', () {
    final endedAt = DateTime.parse('2026-05-15T17:30:00-03:00').toLocal();

    final dto = JourneyDto.fromJson({
      'id': 10,
      'collaborator_id': 4,
      'started_at': '2026-05-15T08:03:00-03:00',
      'ended_at': '2026-05-15T17:30:00-03:00',
      'duration_seconds': 28_800,
      'summary': 'Dia focado em integrações e revisão de PRs.',
      'journey_planned_activities': <Map<String, dynamic>>[],
      'status': 'completed',
      'created_at': '2026-05-15T08:03:01-03:00',
      'updated_at': '2026-05-15T17:30:01-03:00',
    });

    expect(dto.endedAt, endedAt);
    expect(dto.duration, const Duration(hours: 8));
    expect(dto.summary, 'Dia focado em integrações e revisão de PRs.');

    final entity = dto.toEntity();
    expect(entity.endedAt, endedAt);
    expect(entity.duration, const Duration(hours: 8));
    expect(entity.summary, 'Dia focado em integrações e revisão de PRs.');
    expect(entity.status, JourneyStatus.completed);
  });

  test('fromResponseJson lê jornada aninhada em journey', () {
    final dto = JourneyDto.fromResponseJson({
      'journey': {
        'id': 10,
        'collaborator_id': 4,
        'started_at': '2026-05-15T08:03:00-03:00',
        'journey_planned_activities': <Map<String, dynamic>>[],
        'status': 'completed',
        'created_at': '2026-05-15T08:03:01-03:00',
        'updated_at': '2026-05-15T17:30:01-03:00',
      },
    });

    expect(dto.id, 10);
    expect(dto.status, JourneyStatus.completed);
  });

  test('fromResponseJson usa o root quando não há chave journey', () {
    final dto = JourneyDto.fromResponseJson({
      'id': 11,
      'collaborator_id': 4,
      'started_at': '2026-05-15T08:03:00-03:00',
      'journey_planned_activities': <Map<String, dynamic>>[],
      'status': 'in_progress',
      'created_at': '2026-05-15T08:03:01-03:00',
      'updated_at': '2026-05-15T08:03:01-03:00',
    });

    expect(dto.id, 11);
    expect(dto.status, JourneyStatus.inProgress);
  });
}
