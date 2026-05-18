import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_collaborator_dto.dart';

void main() {
  test('mapeia colaborador da listagem', () {
    final dto = ManagerCollaboratorDto.fromJson(<String, dynamic>{
      'id': 1,
      'first_name': 'Maria',
      'current_journey_status': 'in_progress',
      'hours_today_seconds': 8100,
      'adherence_percentage': 95,
    });

    expect(dto.id, 1);
    expect(dto.firstName, 'Maria');
    expect(dto.currentJourneyStatus, JourneyStatus.inProgress);
    expect(dto.hoursTodaySeconds, 8100);
    expect(dto.adherencePercentage, 95);

    final entity = dto.toEntity();
    expect(entity.hoursTodayLabel, '02:15');
    expect(entity.adherenceLabel, '95%');
    expect(entity.currentJourneyStatusLabel, 'EM ANDAMENTO');
  });

  test('aderência nula mapeia para label -', () {
    final dto = ManagerCollaboratorDto.fromJson(<String, dynamic>{
      'id': 3,
      'first_name': 'Carla',
      'current_journey_status': 'completed',
      'hours_today_seconds': 34200,
      'adherence_percentage': null,
    });

    expect(dto.adherencePercentage, isNull);
    expect(dto.toEntity().adherenceLabel, '-');
  });
}
