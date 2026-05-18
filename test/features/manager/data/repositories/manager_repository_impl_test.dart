import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/manager/data/datasources/manager_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/core/pagination/page_dto.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_collaborator_dto.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_overview_dto.dart';
import 'package:registro_ponto_frontend/features/manager/data/models/manager_profile_dto.dart';
import 'package:registro_ponto_frontend/features/manager/data/repositories/manager_repository_impl.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_collaborator.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_overview.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_profile.dart';

class _MockRemote extends Mock implements ManagerRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late ManagerRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = ManagerRepositoryImpl(remote: remote);
  });

  test('fetchProfile em sucesso devolve Success(ManagerProfile)', () async {
    when(() => remote.fetchProfile()).thenAnswer(
      (_) async => const ManagerProfileDto(userId: 1, firstName: 'Ana'),
    );

    final result = await repository.fetchProfile();

    expect(
      result,
      const Success<ManagerProfile, String>(
        ManagerProfile(userId: 1, firstName: 'Ana'),
      ),
    );
  });

  test('fetchProfile em ApiException devolve Failure com a mensagem', () async {
    when(
      () => remote.fetchProfile(),
    ).thenThrow(ApiException('Perfil indisponível'));

    final result = await repository.fetchProfile();

    expect(
      result,
      const Failure<ManagerProfile, String>('Perfil indisponível'),
    );
  });

  test('fetchProfile em erro genérico devolve Failure com toString', () async {
    when(() => remote.fetchProfile()).thenThrow(Exception('oops'));

    final result = await repository.fetchProfile();

    expect(result, isA<Failure<ManagerProfile, String>>());
    expect(
      (result as Failure<ManagerProfile, String>).error,
      'Exception: oops',
    );
  });

  test('fetchOverview em sucesso devolve Success(ManagerOverview)', () async {
    when(
      () => remote.fetchOverview(
        startDate: DateTime(2026, 5, 17),
        endDate: DateTime(2026, 5, 17),
      ),
    ).thenAnswer(
      (_) async => const ManagerOverviewDto(
        durationSeconds: 247_500,
        journeysInProgress: 5,
        averageAdherencePercentage: 87,
        activitiesCompleted: 32,
        unplannedActivities: 8,
      ),
    );

    final result = await repository.fetchOverview(
      startDate: DateTime(2026, 5, 17),
      endDate: DateTime(2026, 5, 17),
    );

    expect(
      result,
      const Success<ManagerOverview, String>(
        ManagerOverview(
          durationSeconds: 247_500,
          journeysInProgress: 5,
          averageAdherencePercentage: 87,
          activitiesCompleted: 32,
          unplannedActivities: 8,
        ),
      ),
    );
  });

  test(
    'fetchOverview em ApiException devolve Failure com a mensagem',
    () async {
      when(
        () => remote.fetchOverview(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenThrow(ApiException('Visão geral indisponível'));

      final result = await repository.fetchOverview(
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 17),
      );

      expect(
        result,
        const Failure<ManagerOverview, String>('Visão geral indisponível'),
      );
    },
  );

  test('fetchCollaborators em sucesso devolve página de colaboradores', () async {
    when(
      () => remote.fetchCollaborators(page: 0, pageSize: 10, query: 'maria'),
    ).thenAnswer(
      (_) async => PageDto(
        content: [
          ManagerCollaboratorDto(
            id: 1,
            firstName: 'Maria',
            currentJourneyStatus: JourneyStatus.inProgress,
            hoursTodaySeconds: 8100,
            adherencePercentage: 95,
          ),
        ],
        pageNumber: 0,
        pageSize: 10,
        totalElements: 1,
        isFirst: true,
        isLast: true,
        empty: false,
      ),
    );

    final result = await repository.fetchCollaborators(
      page: 0,
      pageSize: 10,
      query: 'maria',
    );

    expect(result, isA<Success>());
    final page = (result as Success).value;
    expect(page.content, [
      const ManagerCollaborator(
        id: 1,
        firstName: 'Maria',
        currentJourneyStatus: JourneyStatus.inProgress,
        hoursTodaySeconds: 8100,
        adherencePercentage: 95,
      ),
    ]);
  });
}
