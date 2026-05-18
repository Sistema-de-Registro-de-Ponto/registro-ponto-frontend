import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_overview_dto.dart';

void main() {
  test('fromJson mapeia campos do overview', () {
    const json = {
      'duration_seconds': 247_500,
      'journeys_progress': 5,
      'average_adherence_percentage': 87,
      'activities_completed': 32,
      'unplanned_activities': 8,
    };

    final dto = ManagerOverviewDto.fromJson(json);

    expect(dto.durationSeconds, 247_500);
    expect(dto.journeysInProgress, 5);
    expect(dto.averageAdherencePercentage, 87);
    expect(dto.activitiesCompleted, 32);
    expect(dto.unplannedActivities, 8);
    expect(dto.toEntity().durationSeconds, 247_500);
    expect(dto.toEntity().journeysInProgress, 5);
  });
}
