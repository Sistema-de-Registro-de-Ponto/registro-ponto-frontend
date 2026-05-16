import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';
import 'package:registro_ponto_frontend/features/activity/data/repositories/activity_repository_provider.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';
import 'package:registro_ponto_frontend/features/activity/domain/repositories/activity_repository.dart';
import 'package:registro_ponto_frontend/features/activity/presentation/widgets/planned_activities_section.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_view_model.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/journey_section.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/widgets/unplanned_activities_section.dart';

class _MockJourneyRepository extends Mock implements JourneyRepository {}

class _MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late _MockJourneyRepository repo;
  late _MockActivityRepository activityRepo;

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

  Widget buildDashboardLike() {
    return ProviderScope(
      overrides: [
        journeyRepositoryProvider.overrideWithValue(repo),
        activityRepositoryProvider.overrideWithValue(activityRepo),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Consumer(
              builder: (context, ref, _) {
                final journeyState = ref.watch(journeyViewModelProvider);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const JourneySection(),
                    if (journeyState.showUnplannedActivitiesPanel)
                      const UnplannedActivitiesSection(),
                    if (journeyState.showPlannedActivitiesChecklist)
                      const PlannedActivitiesSection(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSubject() => buildDashboardLike();

  setUp(() {
    repo = _MockJourneyRepository();
    activityRepo = _MockActivityRepository();
    journeyInProgress = buildJourneyInProgress();
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => const Success<Journey?, String>(null));
    when(() => activityRepo.fetchPlannedActivities()).thenAnswer(
      (_) async => const Success<List<PlannedActivity>, String>([]),
    );
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
    await tester.pump();
    await tester.tap(find.text('INICIAR JORNADA'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Iniciar'));
    await tester.pumpAndSettle();

    expect(find.text('JORNADA EM ANDAMENTO'), findsOneWidget);
    expect(find.text('INICIAR JORNADA'), findsNothing);
    expect(find.text('Atividades planejadas para hoje'), findsOneWidget);
    expect(find.text('Ajustar API de login'), findsOneWidget);
    expect(find.text('Reunião daily'), findsOneWidget);
    expect(find.text('Concluída'), findsOneWidget);
    verify(() => repo.startJourney()).called(1);
  });

  testWidgets('ao encerrar exibe confirmação, resumo e chama a API', (tester) async {
    final endedAt = DateTime.now();
    final completedJourney = Journey(
      id: 10,
      collaboratorId: 4,
      startedAt: journeyInProgress.startedAt,
      endedAt: endedAt,
      duration: const Duration(hours: 8),
      summary: 'Dia produtivo.',
      plannedActivities: journeyInProgress.plannedActivities,
      unplannedActivities: [
        JourneyUnplannedActivity(
          id: 5,
          journeyId: 10,
          description: 'Suporte',
          createdAt: endedAt,
        ),
      ],
      status: JourneyStatus.completed,
      createdAt: journeyInProgress.createdAt,
      updatedAt: endedAt,
    );

    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));
    when(() => repo.endJourney(summary: 'Dia produtivo.'))
        .thenAnswer((_) async => Success<Journey, String>(completedJourney));

    await tester.pumpWidget(buildSubject());
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('ENCERRAR JORNADA'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog).last,
        matching: find.byType(TextFormField),
      ),
      'Dia produtivo.',
    );
    await tester.tap(find.text('Encerrar jornada'));
    await tester.pumpAndSettle();

    expect(find.text('Jornada encerrada'), findsOneWidget);
    expect(find.text('Sua jornada foi finalizada com sucesso.'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    expect(find.text('JORNADA PRONTA PARA INICIAR'), findsOneWidget);
    expect(find.text('INICIAR JORNADA'), findsOneWidget);
    expect(find.text('Atividades planejadas para hoje'), findsNothing);
    expect(find.text('Adicionar atividade planejada'), findsOneWidget);
    expect(find.text('Adicionar atividade não planejada'), findsNothing);
    verify(() => repo.endJourney(summary: 'Dia produtivo.')).called(1);
  });
}
