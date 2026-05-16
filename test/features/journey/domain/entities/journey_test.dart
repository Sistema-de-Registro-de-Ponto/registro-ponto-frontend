import 'package:flutter_test/flutter_test.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

void main() {
  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  test('withUpdatedPlannedActivity substitui apenas o item com o mesmo id', () {
    final journey = Journey(
      id: 10,
      collaboratorId: 4,
      startedAt: startedAt,
      plannedActivities: const [
        JourneyPlannedActivity(
          id: 1,
          plannedActivityId: 7,
          description: 'A',
          checked: true,
        ),
        JourneyPlannedActivity(
          id: 2,
          plannedActivityId: 8,
          description: 'B',
          checked: false,
        ),
      ],
      status: JourneyStatus.inProgress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    final merged = journey.withUpdatedPlannedActivity(
      const JourneyPlannedActivity(
        id: 2,
        plannedActivityId: 8,
        description: 'B',
        checked: true,
      ),
    );

    expect(merged.plannedActivities.first.checked, isTrue);
    expect(merged.plannedActivities.last.checked, isTrue);
  });

  test('withUpdatedPlannedActivity preserva endedAt, duration e summary', () {
    final endedAt = DateTime.parse('2026-05-15T17:30:00-03:00').toLocal();
    final journey = Journey(
      id: 10,
      collaboratorId: 4,
      startedAt: startedAt,
      endedAt: endedAt,
      duration: const Duration(hours: 8),
      summary: 'Resumo',
      plannedActivities: const [
        JourneyPlannedActivity(
          id: 1,
          plannedActivityId: 7,
          description: 'A',
          checked: true,
        ),
      ],
      status: JourneyStatus.completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    final merged = journey.withUpdatedPlannedActivity(
      const JourneyPlannedActivity(
        id: 1,
        plannedActivityId: 7,
        description: 'A',
        checked: false,
      ),
    );

    expect(merged.endedAt, endedAt);
    expect(merged.duration, const Duration(hours: 8));
    expect(merged.summary, 'Resumo');
  });
}
