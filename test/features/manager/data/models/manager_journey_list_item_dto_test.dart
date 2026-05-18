import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_journey_list_item_dto.dart';

void main() {
  test('mapeia item de listagem de jornadas do gestor', () {
    final dto = ManagerJourneyListItemDto.fromJson(<String, dynamic>{
      'id': 42,
      'journey_date': '2025-05-14',
      'collaborator_id': 1,
      'collaborator_first_name': 'Maria Silva',
      'started_at': '2025-05-14T08:03:00-03:00',
      'ended_at': null,
      'duration_seconds': 8460,
      'status': 'in_progress',
    });

    expect(dto.id, 42);
    expect(dto.collaboratorFirstName, 'Maria Silva');
    expect(dto.status, JourneyStatus.inProgress);
    expect(dto.duration, const Duration(seconds: 8460));

    final entity = dto.toEntity();
    expect(entity.entryLabel, '08:03');
    expect(entity.exitLabel, '-');
    expect(entity.isInProgress, isTrue);
  });
}
