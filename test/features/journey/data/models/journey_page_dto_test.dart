import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_page_dto.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

void main() {
  final journeyJson = <String, dynamic>{
    'id': 10,
    'collaborator_id': 4,
    'started_at': '2026-05-15T08:03:00-03:00',
    'journey_planned_activities': <Map<String, dynamic>>[],
    'status': 'completed',
    'created_at': '2026-05-15T08:03:01-03:00',
    'updated_at': '2026-05-15T08:03:01-03:00',
  };

  test('mapeia content e last da página Spring', () {
    final dto = JourneyPageDto.fromJson(<String, dynamic>{
      'content': [journeyJson],
      'last': false,
      'first': true,
      'size': 20,
      'number': 0,
    });

    expect(dto.journeys, hasLength(1));
    expect(dto.journeys.first.id, 10);
    expect(dto.journeys.first.status, JourneyStatus.completed);
    expect(dto.last, isFalse);
  });

  test('toEntity mapeia jornadas e last', () {
    final dto = JourneyPageDto.fromJson(<String, dynamic>{
      'content': [journeyJson],
      'last': false,
    });

    final page = dto.toEntity();

    expect(page.journeys, hasLength(1));
    expect(page.journeys.first.id, 10);
    expect(page.last, isFalse);
    expect(page.hasMore, isTrue);
  });

  test('content vazio e last true quando não há jornadas', () {
    final dto = JourneyPageDto.fromJson(<String, dynamic>{
      'content': <dynamic>[],
      'last': true,
    });

    expect(dto.journeys, isEmpty);
    expect(dto.last, isTrue);
  });
}
