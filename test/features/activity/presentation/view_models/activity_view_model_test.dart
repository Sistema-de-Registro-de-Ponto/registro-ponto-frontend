import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/activity/data/repositories/activity_repository_provider.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';
import 'package:registro_ponto_frontend/features/activity/domain/repositories/activity_repository.dart';
import 'package:registro_ponto_frontend/features/activity/presentation/view_models/activity_state.dart';
import 'package:registro_ponto_frontend/features/activity/presentation/view_models/activity_view_model.dart';

class _MockActivityRepository extends Mock implements ActivityRepository {}

void main() {
  late _MockActivityRepository repo;
  late ProviderContainer container;

  final createdAt = DateTime.parse('2026-05-15T12:08:22.904747-03:00').toLocal();
  final existing = PlannedActivity(id: 1, description: 'Reunião', createdAt: createdAt);
  final created = PlannedActivity(id: 2, description: 'Nova tarefa', createdAt: createdAt);

  ActivityViewModel notifier() => container.read(activityViewModelProvider.notifier);

  ActivityState readState() => container.read(activityViewModelProvider);

  Future<void> waitForInitialLoad() async {
    container.read(activityViewModelProvider);
    await container.read(activityViewModelProvider.notifier).loadPlannedActivities();
  }

  setUp(() {
    repo = _MockActivityRepository();
    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => const Success<List<PlannedActivity>, String>([]));
    container = ProviderContainer(
      overrides: [activityRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  test('inicia com ActivityState default e carrega atividades', () async {
    expect(readState(), const ActivityState());

    await waitForInitialLoad();
    verify(() => repo.fetchPlannedActivities()).called(greaterThanOrEqualTo(1));
  });

  test('setDescription atualiza o texto e limpa erro de campo', () async {
    await waitForInitialLoad();

    notifier().setDescription('Planejamento');

    expect(readState().description, 'Planejamento');
    expect(readState().descriptionErrorText, isNull);
  });

  test('loadPlannedActivities em sucesso preenche a lista', () async {
    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => Success<List<PlannedActivity>, String>([existing]));

    await notifier().loadPlannedActivities();

    expect(readState().isLoading, isFalse);
    expect(readState().activities, [existing]);
    expect(readState().failure, isNull);
  });

  test('loadPlannedActivities em Failure preenche failure', () async {
    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => const Failure<List<PlannedActivity>, String>('Erro ao carregar'));

    await notifier().loadPlannedActivities();

    expect(readState().isLoading, isFalse);
    expect(readState().failure, 'Erro ao carregar');
  });

  test('submitPlannedActivity com descrição vazia define descriptionErrorText', () async {
    await waitForInitialLoad();

    await notifier().submitPlannedActivity();

    expect(readState().descriptionErrorText, 'Campo obrigatório');
    verifyNever(() => repo.createPlannedActivity(description: any(named: 'description')));
  });

  test('submitPlannedActivity insere nova atividade no topo da lista', () async {
    final older = PlannedActivity(
      id: 1,
      description: 'Antiga',
      createdAt: DateTime.parse('2026-05-15T10:00:00-03:00').toLocal(),
    );
    final newer = PlannedActivity(
      id: 2,
      description: 'Nova tarefa',
      createdAt: DateTime.parse('2026-05-15T12:08:22.904747-03:00').toLocal(),
    );

    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => Success<List<PlannedActivity>, String>([older]));
    when(() => repo.createPlannedActivity(description: 'Nova tarefa'))
        .thenAnswer((_) async => Success<PlannedActivity, String>(newer));

    await waitForInitialLoad();
    notifier().setDescription('Nova tarefa');
    await notifier().submitPlannedActivity();

    expect(readState().activities.map((item) => item.id), [2, 1]);
  });

  test('loadPlannedActivities ordena da mais recente para a mais antiga', () async {
    final older = PlannedActivity(
      id: 1,
      description: 'Antiga',
      createdAt: DateTime.parse('2026-05-15T10:00:00-03:00').toLocal(),
    );
    final newer = PlannedActivity(
      id: 2,
      description: 'Recente',
      createdAt: DateTime.parse('2026-05-15T12:08:22.904747-03:00').toLocal(),
    );

    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => Success<List<PlannedActivity>, String>([older, newer]));

    await notifier().loadPlannedActivities();

    expect(readState().activities.map((item) => item.id), [2, 1]);
  });

  test('submitPlannedActivity em sucesso adiciona atividade e limpa descrição', () async {
    await waitForInitialLoad();

    when(() => repo.createPlannedActivity(description: 'Nova tarefa'))
        .thenAnswer((_) async => Success<PlannedActivity, String>(created));

    notifier().setDescription('Nova tarefa');
    await notifier().submitPlannedActivity();

    expect(readState().isLoading, isFalse);
    expect(readState().description, isEmpty);
    expect(readState().activities, [created]);
    expect(readState().activities.single.timeLabel, created.timeLabel);
    expect(readState().failure, isNull);
  });

  test('submitPlannedActivity em Failure preenche failure', () async {
    await waitForInitialLoad();

    when(() => repo.createPlannedActivity(description: 'x')).thenAnswer(
      (_) async => const Failure<PlannedActivity, String>('Não foi possível salvar'),
    );

    notifier().setDescription('x');
    await notifier().submitPlannedActivity();

    expect(readState().isLoading, isFalse);
    expect(readState().failure, 'Não foi possível salvar');
  });

  test('deletePlannedActivity em sucesso remove da lista', () async {
    when(() => repo.fetchPlannedActivities())
        .thenAnswer((_) async => Success<List<PlannedActivity>, String>([existing]));
    when(() => repo.deletePlannedActivity(id: 1))
        .thenAnswer((_) async => Success<PlannedActivity, String>(existing));

    await waitForInitialLoad();
    await notifier().deletePlannedActivity(1);

    expect(readState().isLoading, isFalse);
    expect(readState().activities, isEmpty);
  });

  test('deletePlannedActivity em Failure preenche failure', () async {
    await waitForInitialLoad();

    when(() => repo.deletePlannedActivity(id: 99)).thenAnswer(
      (_) async => const Failure<PlannedActivity, String>('Não foi possível remover'),
    );

    await notifier().deletePlannedActivity(99);

    expect(readState().isLoading, isFalse);
    expect(readState().failure, 'Não foi possível remover');
  });
}
