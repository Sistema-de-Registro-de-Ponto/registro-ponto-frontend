import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/journey_section.dart';

class _MockJourneyRepository extends Mock implements JourneyRepository {}

void main() {
  late _MockJourneyRepository repo;

  late Journey journeyInProgress;

  Journey buildJourneyInProgress() {
    final startedAt = DateTime.now().subtract(const Duration(hours: 2, minutes: 21, seconds: 35));
    final timestamps = DateTime.now();

    return Journey(
    id: 10,
    collaboratorId: 4,
    startedAt: startedAt,
    plannedActivities: const [
      JourneyPlannedActivity(
        id: 1,
        plannedActivityId: 7,
        description: 'Ajustar API de login',
        checked: true,
      ),
      JourneyPlannedActivity(
        id: 2,
        plannedActivityId: 8,
        description: 'Reunião daily',
        checked: false,
      ),
    ],
    status: JourneyStatus.inProgress,
    createdAt: timestamps,
    updatedAt: timestamps,
    );
  }

  Widget buildSubject() {
    return ProviderScope(
      overrides: [journeyRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: Scaffold(body: JourneySection())),
    );
  }

  setUp(() {
    repo = _MockJourneyRepository();
    journeyInProgress = buildJourneyInProgress();
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => const Success<Journey?, String>(null));
  });

  testWidgets('exibe botão iniciar jornada quando não há jornada ativa', (tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('JORNADA PRONTA PARA INICIAR'), findsOneWidget);
    expect(find.text('INICIAR JORNADA'), findsOneWidget);
    expect(find.text('Atividades planejadas para hoje'), findsNothing);
  });

  testWidgets('ao carregar exibe jornada em andamento retomada da API', (tester) async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(find.text('JORNADA EM ANDAMENTO'), findsOneWidget);
    expect(find.text('INICIAR JORNADA'), findsNothing);
    expect(find.text('Atividades planejadas para hoje'), findsOneWidget);
  });

  testWidgets('após iniciar exibe checklist e oculta botão iniciar', (tester) async {
    when(() => repo.startJourney())
        .thenAnswer((_) async => Success<Journey, String>(journeyInProgress));

    await tester.pumpWidget(buildSubject());
    await tester.pump();
    await tester.tap(find.text('INICIAR JORNADA'));
    await tester.pump();
    await tester.pump();

    expect(find.text('JORNADA EM ANDAMENTO'), findsOneWidget);
    expect(find.text('INICIAR JORNADA'), findsNothing);
    expect(find.text('Atividades planejadas para hoje'), findsOneWidget);
    expect(find.text('Ajustar API de login'), findsOneWidget);
    expect(find.text('Reunião daily'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
  });
}
