import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_state.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_view_model.dart';

class _MockJourneyRepository extends Mock implements JourneyRepository {}

void main() {
  late _MockJourneyRepository repo;
  late ProviderContainer container;

  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  late Journey journeyInProgress;
  late Journey journeyCompleted;

  JourneyViewModel notifier() => container.read(journeyViewModelProvider.notifier);

  JourneyState readState() => container.read(journeyViewModelProvider);

  Future<void> waitForInitialLoad() async {
    container.read(journeyViewModelProvider);
    await notifier().loadInProgressJourney();
  }

  setUp(() {
    repo = _MockJourneyRepository();
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => const Success<Journey?, String>(null));
    container = ProviderContainer(
      overrides: [journeyRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    journeyInProgress = Journey(
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
      ],
      status: JourneyStatus.inProgress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    journeyCompleted = Journey(
      id: 11,
      collaboratorId: 4,
      startedAt: startedAt,
      plannedActivities: const [],
      status: JourneyStatus.completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  });

  test('inicia com JourneyState default e carrega jornada em andamento', () async {
    expect(readState(), const JourneyState());

    await waitForInitialLoad();

    expect(readState().canStartJourney, isTrue);
    expect(readState().isJourneyInProgress, isFalse);
    verify(() => repo.fetchInProgressJourney()).called(greaterThanOrEqualTo(1));
  });

  test('loadInProgressJourney preenche jornada em andamento', () async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    await waitForInitialLoad();

    expect(readState().isLoading, isFalse);
    expect(readState().journey, journeyInProgress);
    expect(readState().isJourneyInProgress, isTrue);
  });

  test('loadInProgressJourney em Failure preenche failure', () async {
    when(() => repo.fetchInProgressJourney()).thenAnswer(
      (_) async => const Failure<Journey?, String>('Erro ao carregar jornada'),
    );

    await waitForInitialLoad();

    expect(readState().isLoading, isFalse);
    expect(readState().failure, 'Erro ao carregar jornada');
  });

  test('startJourney em sucesso preenche a jornada', () async {
    when(() => repo.startJourney())
        .thenAnswer((_) async => Success<Journey, String>(journeyInProgress));

    await waitForInitialLoad();
    await notifier().startJourney();

    expect(readState().isLoading, isFalse);
    expect(readState().journey, journeyInProgress);
    expect(readState().isJourneyInProgress, isTrue);
    expect(readState().failure, isNull);
    verify(() => repo.startJourney()).called(1);
  });

  test('startJourney com jornada em andamento não chama o repositório', () async {
    when(() => repo.startJourney())
        .thenAnswer((_) async => Success<Journey, String>(journeyInProgress));

    await waitForInitialLoad();
    await notifier().startJourney();
    await notifier().startJourney();

    expect(readState().failure, 'Já existe uma jornada em andamento');
    verify(() => repo.startJourney()).called(1);
  });

  test('startJourney em Failure preenche failure', () async {
    when(() => repo.startJourney()).thenAnswer(
      (_) async => const Failure<Journey, String>('Jornada já em andamento'),
    );

    await waitForInitialLoad();
    await notifier().startJourney();

    expect(readState().isLoading, isFalse);
    expect(readState().journey, isNull);
    expect(readState().failure, 'Jornada já em andamento');
  });

  test('startJourney após jornada concluída permite nova jornada', () async {
    final newJourney = Journey(
      id: 12,
      collaboratorId: 4,
      startedAt: startedAt,
      plannedActivities: const [],
      status: JourneyStatus.inProgress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    when(() => repo.startJourney())
        .thenAnswer((_) async => Success<Journey, String>(newJourney));

    await waitForInitialLoad();
    notifier().state = JourneyState(journey: journeyCompleted);
    expect(readState().canStartJourney, isTrue);

    await notifier().startJourney();

    expect(readState().journey, newJourney);
    verify(() => repo.startJourney()).called(1);
  });

  test('setChecked em sucesso atualiza atividade na jornada sem novo GET', () async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    final updatedActivity = JourneyPlannedActivity(
      id: 1,
      plannedActivityId: 7,
      description: 'Ajustar API de login',
      checked: false,
    );

    when(
      () => repo.updatePlannedActivityChecked(
        journeyPlannedActivityId: 1,
        checked: false,
      ),
    ).thenAnswer((_) async => Success<JourneyPlannedActivity, String>(updatedActivity));

    await waitForInitialLoad();

    await notifier().setChecked(1, false);

    expect(readState().togglingPlannedActivityId, isNull);
    expect(readState().failure, isNull);
    expect(readState().journey?.plannedActivities.single.checked, isFalse);
    verify(
      () => repo.updatePlannedActivityChecked(
        journeyPlannedActivityId: 1,
        checked: false,
      ),
    ).called(1);
  });

  test('setChecked em Failure preenche failure', () async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    when(
      () => repo.updatePlannedActivityChecked(
        journeyPlannedActivityId: 1,
        checked: false,
      ),
    ).thenAnswer(
      (_) async =>
          const Failure<JourneyPlannedActivity, String>('Não foi possível atualizar'),
    );

    await waitForInitialLoad();

    await notifier().setChecked(1, false);

    expect(readState().togglingPlannedActivityId, isNull);
    expect(readState().failure, 'Não foi possível atualizar');
    expect(readState().journey?.plannedActivities.single.checked, isTrue);
  });

  test('submitUnplannedActivity em sucesso anexa atividade à jornada', () async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    final createdAt = DateTime.parse('2026-05-15T09:15:00-03:00').toLocal();
    final created = JourneyUnplannedActivity(
      id: 5,
      journeyId: 10,
      description: 'Nova tarefa',
      createdAt: createdAt,
    );

    when(
      () => repo.createUnplannedActivity(
        journeyId: 10,
        description: 'Nova tarefa',
      ),
    ).thenAnswer((_) async => Success<JourneyUnplannedActivity, String>(created));

    await waitForInitialLoad();

    notifier().setUnplannedDescription('Nova tarefa');
    await notifier().submitUnplannedActivity();

    expect(readState().unplannedDescription, '');
    expect(readState().journey?.unplannedActivities.single, created);
    verify(
      () => repo.createUnplannedActivity(
        journeyId: 10,
        description: 'Nova tarefa',
      ),
    ).called(1);
  });

  test('submitUnplannedActivity com descrição vazia define erro de validação', () async {
    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));

    await waitForInitialLoad();

    notifier().setUnplannedDescription('   ');
    await notifier().submitUnplannedActivity();

    expect(readState().unplannedDescriptionErrorText, 'Campo obrigatório');
  });

  test('deleteUnplannedActivity em sucesso remove da jornada', () async {
    final journeyWithUnplanned = Journey(
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
      ],
      unplannedActivities: [
        JourneyUnplannedActivity(
          id: 5,
          journeyId: 10,
          description: 'Remover',
          createdAt: updatedAt,
        ),
      ],
      status: JourneyStatus.inProgress,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    when(() => repo.fetchInProgressJourney())
        .thenAnswer((_) async => Success<Journey?, String>(journeyWithUnplanned));

    when(() => repo.deleteUnplannedActivity(id: 5))
        .thenAnswer((_) async => const Success<int, String>(5));

    await waitForInitialLoad();

    await notifier().deleteUnplannedActivity(5);

    expect(readState().journey?.unplannedActivities, isEmpty);
    verify(() => repo.deleteUnplannedActivity(id: 5)).called(1);
  });

  group('endJourney', () {
    final endedAt = DateTime.parse('2026-05-15T17:30:00-03:00').toLocal();
    final completedUpdatedAt =
        DateTime.parse('2026-05-15T17:30:01-03:00').toLocal();

    test('em sucesso limpa jornada e formulário para nova jornada', () async {
      final completed = Journey(
        id: 10,
        collaboratorId: 4,
        startedAt: startedAt,
        endedAt: endedAt,
        duration: const Duration(hours: 8),
        summary: 'Dia produtivo.',
        plannedActivities: journeyInProgress.plannedActivities,
        status: JourneyStatus.completed,
        createdAt: createdAt,
        updatedAt: completedUpdatedAt,
      );

      when(() => repo.fetchInProgressJourney())
          .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));
      when(
        () => repo.endJourney(summary: 'Dia produtivo.'),
      ).thenAnswer((_) async => Success<Journey, String>(completed));

      await waitForInitialLoad();
      notifier().setUnplannedDescription('Rascunho');
      await notifier().endJourney('  Dia produtivo.  ');

      expect(readState().isEndingJourney, isFalse);
      expect(readState().journey, isNull);
      expect(readState().canStartJourney, isTrue);
      expect(readState().showPlannedActivitiesChecklist, isTrue);
      expect(readState().showJourneyPlannedChecklist, isFalse);
      expect(readState().unplannedDescription, '');
      verify(() => repo.endJourney(summary: 'Dia produtivo.')).called(1);
    });

    test('em Failure preenche failure', () async {
      when(() => repo.fetchInProgressJourney())
          .thenAnswer((_) async => Success<Journey?, String>(journeyInProgress));
      when(() => repo.endJourney(summary: 'Resumo')).thenAnswer(
        (_) async => const Failure<Journey, String>('Não foi possível encerrar'),
      );

      await waitForInitialLoad();
      await notifier().endJourney('Resumo');

      expect(readState().isEndingJourney, isFalse);
      expect(readState().isJourneyInProgress, isTrue);
      expect(readState().failure, 'Não foi possível encerrar');
    });

    test('com jornada concluída não chama o repositório', () async {
      await waitForInitialLoad();
      notifier().state = JourneyState(journey: journeyCompleted);

      await notifier().endJourney('Resumo');

      expect(readState().failure, 'A jornada não está em andamento');
      verifyNever(() => repo.endJourney(summary: any(named: 'summary')));
    });
  });

  test('setChecked com jornada concluída não chama o repositório', () async {
    await waitForInitialLoad();
    notifier().state = JourneyState(journey: journeyCompleted);

    await notifier().setChecked(1, false);

    verifyNever(
      () => repo.updatePlannedActivityChecked(
        journeyPlannedActivityId: any(named: 'journeyPlannedActivityId'),
        checked: any(named: 'checked'),
      ),
    );
  });

  test('submitUnplannedActivity com jornada concluída não chama o repositório', () async {
    await waitForInitialLoad();
    notifier().state = JourneyState(journey: journeyCompleted);

    notifier().setUnplannedDescription('Nova');
    await notifier().submitUnplannedActivity();

    verifyNever(
      () => repo.createUnplannedActivity(
        journeyId: any(named: 'journeyId'),
        description: any(named: 'description'),
      ),
    );
  });

  test('showPlannedActivitiesChecklist exibe seção com jornada concluída', () async {
    await waitForInitialLoad();
    notifier().state = JourneyState(journey: journeyCompleted);

    expect(readState().showPlannedActivitiesChecklist, isTrue);
  });

  test('showJourneyPlannedChecklist oculta checklist quando concluída', () async {
    final completedWithActivities = Journey(
      id: 10,
      collaboratorId: 4,
      startedAt: startedAt,
      plannedActivities: journeyInProgress.plannedActivities,
      status: JourneyStatus.completed,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    await waitForInitialLoad();
    notifier().state = JourneyState(journey: completedWithActivities);

    expect(readState().showJourneyPlannedChecklist, isFalse);
    expect(readState().isJourneyInProgress, isFalse);
  });
}
