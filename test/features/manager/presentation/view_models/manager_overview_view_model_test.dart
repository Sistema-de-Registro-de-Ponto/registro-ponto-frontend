import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/manager/data/repositories/manager_repository_provider.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_overview.dart';
import 'package:registro_ponto_frontend/features/manager/domain/repositories/manager_repository.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_overview_view_model.dart';

class _MockRepository extends Mock implements ManagerRepository {}

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  const overview = ManagerOverview(
    durationSeconds: 247_500,
    journeysInProgress: 5,
    averageAdherencePercentage: 87,
    activitiesCompleted: 32,
    unplannedActivities: 8,
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [managerRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  ManagerOverviewViewModel notifier() =>
      container.read(managerOverviewViewModelProvider.notifier);

  test('estado inicial usa o dia de hoje como período', () {
    final today = DateTime.now();
    final state = container.read(managerOverviewViewModelProvider);

    expect(state.startDate.year, today.year);
    expect(state.startDate.month, today.month);
    expect(state.startDate.day, today.day);
    expect(state.endDate, state.startDate);
    expect(state.overview, isNull);
  });

  test('loadOverview preenche overview em sucesso', () async {
    when(
      () => repository.fetchOverview(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) async => const Success(overview));

    await notifier().loadOverview();

    final state = container.read(managerOverviewViewModelProvider);
    expect(state.overview, overview);
    expect(state.isLoading, isFalse);
    expect(state.failure, isNull);
  });

  test('loadOverview em falha expõe mensagem', () async {
    when(
      () => repository.fetchOverview(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) async => const Failure('Erro ao carregar'));

    await notifier().loadOverview();

    final state = container.read(managerOverviewViewModelProvider);
    expect(state.overview, isNull);
    expect(state.failure, 'Erro ao carregar');
  });

  test('changePeriod atualiza datas e recarrega overview', () async {
    when(
      () => repository.fetchOverview(
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer((_) async => const Success(overview));

    await notifier().changePeriod(
      DateTimeRange(start: DateTime(2026, 5, 1), end: DateTime(2026, 5, 10)),
    );

    final state = container.read(managerOverviewViewModelProvider);
    expect(state.startDate, DateTime(2026, 5, 1));
    expect(state.endDate, DateTime(2026, 5, 10));
    expect(state.overview, overview);

    verify(
      () => repository.fetchOverview(
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 10),
      ),
    ).called(1);
  });
}
