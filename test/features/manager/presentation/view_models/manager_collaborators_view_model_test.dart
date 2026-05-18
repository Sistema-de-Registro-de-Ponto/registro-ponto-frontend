import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/data/repositories/manager_repository_provider.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';
import 'package:registro_ponto_frontend/core/pagination/page.dart';
import 'package:registro_ponto_frontend/features/manager/domain/repositories/manager_repository.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_collaborators_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _MockRepository extends Mock implements ManagerRepository {}

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  const collaborator = ManagerCollaborator(
    id: 1,
    firstName: 'Maria',
    currentJourneyStatus: JourneyStatus.inProgress,
    hoursTodaySeconds: 8100,
    adherencePercentage: 95,
  );

  const page = Page(
    content: [collaborator],
    pageNumber: 0,
    pageSize: 10,
    totalElements: 1,
    isFirst: true,
    isLast: true,
    empty: false,
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [managerRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  ManagerCollaboratorsViewModel notifier() =>
      container.read(managerCollaboratorsViewModelProvider.notifier);

  test('loadCollaborators preenche lista em sucesso', () async {
    when(
      () => repository.fetchCollaborators(page: 0, pageSize: 10, query: null),
    ).thenAnswer((_) async => const Success(page));

    await notifier().loadCollaborators();

    final state = container.read(managerCollaboratorsViewModelProvider);
    expect(state.collaborators, [collaborator]);
    expect(state.totalElements, 1);
    expect(state.isLoading, isFalse);
  });

  test('loadCollaborators em falha expõe mensagem', () async {
    when(
      () => repository.fetchCollaborators(page: 0, pageSize: 10, query: null),
    ).thenAnswer((_) async => const Failure('Erro ao carregar'));

    await notifier().loadCollaborators();

    final state = container.read(managerCollaboratorsViewModelProvider);
    expect(state.collaborators, isEmpty);
    expect(state.failure, 'Erro ao carregar');
  });

  test('changePage recarrega com nova página', () async {
    when(
      () => repository.fetchCollaborators(page: 1, pageSize: 10, query: null),
    ).thenAnswer((_) async => const Success(page));

    await notifier().changePage(1);

    verify(
      () => repository.fetchCollaborators(page: 1, pageSize: 10, query: null),
    ).called(1);
  });
}
