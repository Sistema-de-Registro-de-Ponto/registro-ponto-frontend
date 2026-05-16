import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

void main() {
  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  final historyStartedAt = DateTime(2025, 5, 14, 8, 3);
  final historyEndedAt = DateTime(2025, 5, 14, 18, 5);
  final historyCreatedAt = DateTime(2025, 5, 14, 8, 3, 1);
  final historyUpdatedAt = DateTime(2025, 5, 14, 8, 3, 1);
  final historyReferenceAt = DateTime(2025, 5, 14, 10, 24);

  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

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

  Journey buildJourney({
    JourneyStatus status = JourneyStatus.completed,
    DateTime? journeyEndedAt,
    Duration? journeyDuration,
    List<JourneyPlannedActivity> plannedActivities = const [],
  }) {
    return Journey(
      id: 1,
      collaboratorId: 4,
      startedAt: historyStartedAt,
      endedAt: journeyEndedAt,
      duration: journeyDuration,
      plannedActivities: plannedActivities,
      status: status,
      createdAt: historyCreatedAt,
      updatedAt: historyUpdatedAt,
    );
  }

  test('historyDateLabel e historyWeekdayLabel usam startedAt', () {
    final journey = buildJourney();

    expect(journey.historyDateLabel, '14/05/2025');
    expect(journey.historyWeekdayLabel, 'Quarta-feira');
    expect(journey.historyEntryLabel, '08:03');
  });

  test('historyExitLabel exibe hora ou traço', () {
    final completed = buildJourney(journeyEndedAt: historyEndedAt);
    final inProgress = buildJourney(status: JourneyStatus.inProgress);

    expect(completed.historyExitLabel, '18:05');
    expect(inProgress.historyExitLabel, '-');
  });

  test('historyTotalHoursLabel usa duration ou tempo decorrido', () {
    final completed = buildJourney(
      journeyDuration: const Duration(hours: 10, minutes: 2),
    );
    final inProgress = buildJourney(status: JourneyStatus.inProgress);

    expect(completed.historyTotalHoursLabel(historyReferenceAt), '10:02');
    expect(inProgress.historyTotalHoursLabel(historyReferenceAt), '02:21');
  });

  test('historyStatusLabel reflete o status da jornada', () {
    expect(
      buildJourney(status: JourneyStatus.inProgress).historyStatusLabel,
      'Em andamento',
    );
    expect(buildJourney().historyStatusLabel, 'Finalizada');
  });

  test('adherencePercent e adherenceLabel calculam checklist', () {
    final journey = buildJourney(
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
        JourneyPlannedActivity(
          id: 3,
          plannedActivityId: 9,
          description: 'C',
          checked: false,
        ),
      ],
    );

    expect(journey.adherencePercent, 33);
    expect(journey.adherenceLabel, '33%');
  });

  test('adherenceLabel exibe traço sem atividades planejadas', () {
    final journey = buildJourney();

    expect(journey.adherencePercent, isNull);
    expect(journey.adherenceLabel, '-');
  });
}
