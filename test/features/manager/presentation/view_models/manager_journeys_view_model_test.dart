import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/pagination/page.dart' as pagination;
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/manager/data/repositories/manager_repository_provider.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_journey_list_item.dart';
import 'package:registro_ponto_frontend/features/manager/domain/repositories/manager_repository.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_journeys_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class _MockRepository extends Mock implements ManagerRepository {}

void main() {
  late _MockRepository repository;
  late ProviderContainer container;

  final journey = ManagerJourneyListItem(
    id: 42,
    journeyDate: DateTime(2025, 5, 14),
    collaboratorId: 1,
    collaboratorFirstName: 'Maria Silva',
    startedAt: DateTime(2025, 5, 14, 8, 3),
    status: JourneyStatus.inProgress,
  );

  final page = pagination.Page(
    content: [journey],
    pageNumber: 0,
    pageSize: 10,
    totalElements: 25,
    isFirst: true,
    isLast: false,
    empty: false,
  );

  setUp(() {
    repository = _MockRepository();
    container = ProviderContainer(
      overrides: [managerRepositoryProvider.overrideWithValue(repository)],
    );
  });

  tearDown(() => container.dispose());

  ManagerJourneysViewModel notifier() =>
      container.read(managerJourneysViewModelProvider.notifier);

  test('loadJourneys sem filtro de período chama API sem datas', () async {
    when(
      () => repository.fetchJourneys(
        page: 0,
        pageSize: 10,
        startDate: null,
        endDate: null,
        collaboratorName: null,
      ),
    ).thenAnswer((_) async => Success(page));

    await notifier().loadJourneys();

    final state = container.read(managerJourneysViewModelProvider);
    expect(state.journeys, [journey]);
    expect(state.totalElements, 25);
    expect(state.usesPeriodFilter, isFalse);
  });

  test('changePeriod envia intervalo na próxima carga', () async {
    when(
      () => repository.fetchJourneys(
        page: 0,
        pageSize: 10,
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 14),
        collaboratorName: null,
      ),
    ).thenAnswer((_) async => Success(page));

    await notifier().changePeriod(
      DateTimeRange(
        start: DateTime(2025, 5, 1),
        end: DateTime(2025, 5, 14),
      ),
    );

    verify(
      () => repository.fetchJourneys(
        page: 0,
        pageSize: 10,
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 14),
        collaboratorName: null,
      ),
    ).called(1);
  });
}
