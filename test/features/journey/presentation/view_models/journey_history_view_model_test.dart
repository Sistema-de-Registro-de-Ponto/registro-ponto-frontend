import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_provider.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_page.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_history_state.dart';
import 'package:registro_ponto_frontend/features/journey/presentation/view_models/journey_history_view_model.dart';

class _MockJourneyRepository extends Mock implements JourneyRepository {}

void main() {
  late _MockJourneyRepository repo;
  late ProviderContainer container;

  final startedAt = DateTime(2025, 5, 14, 8, 3);
  final timestamps = DateTime(2025, 5, 14, 8, 3, 1);

  late Journey journey;

  JourneyHistoryViewModel notifier() =>
      container.read(journeyHistoryViewModelProvider.notifier);

  JourneyHistoryState readState() =>
      container.read(journeyHistoryViewModelProvider);

  setUp(() {
    repo = _MockJourneyRepository();
    container = ProviderContainer(
      overrides: [journeyRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);

    journey = Journey(
      id: 1,
      collaboratorId: 4,
      startedAt: startedAt,
      status: JourneyStatus.completed,
      plannedActivities: const [],
      createdAt: timestamps,
      updatedAt: timestamps,
    );
  });

  test('build define período padrão de 7 dias', () {
    final state = container.read(journeyHistoryViewModelProvider);
    final today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    expect(state.endDate, today);
    expect(state.startDate, today.subtract(const Duration(days: 6)));
  });

  test('loadJourneys preenche lista e hasMore', () async {
    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 0,
        pageSize: 20,
      ),
    ).thenAnswer(
      (_) async => Success(JourneyPage(journeys: [journey], last: false)),
    );

    container.read(journeyHistoryViewModelProvider);
    await notifier().loadJourneys();

    final state = readState();
    expect(state.isLoading, isFalse);
    expect(state.journeys, [journey]);
    expect(state.hasMore, isTrue);
    expect(state.nextPage, 1);
  });

  test('loadJourneys em falha expõe mensagem', () async {
    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: any(named: 'page'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer((_) async => const Failure('Período inválido'));

    container.read(journeyHistoryViewModelProvider);
    await notifier().loadJourneys();

    expect(readState().failure, 'Período inválido');
    expect(readState().journeys, isEmpty);
  });

  test('loadJourneys loadMore acumula página seguinte', () async {
    final secondJourney = Journey(
      id: 2,
      collaboratorId: 4,
      startedAt: DateTime(2025, 5, 13, 8, 3),
      status: JourneyStatus.completed,
      plannedActivities: const [],
      createdAt: timestamps,
      updatedAt: timestamps,
    );

    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 0,
        pageSize: 20,
      ),
    ).thenAnswer(
      (_) async => Success(JourneyPage(journeys: [journey], last: false)),
    );

    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 1,
        pageSize: 20,
      ),
    ).thenAnswer(
      (_) async => Success(JourneyPage(journeys: [secondJourney], last: true)),
    );

    container.read(journeyHistoryViewModelProvider);
    await notifier().loadJourneys();
    await notifier().loadJourneys(loadMore: true);

    final state = readState();
    expect(state.journeys, [journey, secondJourney]);
    expect(state.hasMore, isFalse);
    expect(state.nextPage, 1);
  });

  test('loadJourneys loadMore não chama API sem hasMore', () async {
    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 0,
        pageSize: 20,
      ),
    ).thenAnswer(
      (_) async => Success(JourneyPage(journeys: [journey], last: true)),
    );

    container.read(journeyHistoryViewModelProvider);
    await notifier().loadJourneys();
    await notifier().loadJourneys(loadMore: true);

    verify(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: 0,
        pageSize: 20,
      ),
    ).called(1);
  });

  test('changePeriod atualiza datas e recarrega', () async {
    when(
      () => repo.fetchJourneys(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
        page: any(named: 'page'),
        pageSize: any(named: 'pageSize'),
      ),
    ).thenAnswer(
      (_) async => const Success(JourneyPage(journeys: [], last: true)),
    );

    container.read(journeyHistoryViewModelProvider);
    await notifier().changePeriod(
      DateTimeRange(start: DateTime(2025, 5, 1), end: DateTime(2025, 5, 10)),
    );

    final state = readState();
    expect(state.startDate, DateTime(2025, 5, 1));
    expect(state.endDate, DateTime(2025, 5, 10));

    verify(
      () => repo.fetchJourneys(
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 10),
        page: 0,
        pageSize: 20,
      ),
    ).called(1);
  });
}
