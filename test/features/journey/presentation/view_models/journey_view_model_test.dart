import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
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
}
