import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/data/datasources/journey_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_dto.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_planned_activity_dto.dart';
import 'package:registro_ponto_frontend/features/journey/data/models/journey_unplanned_activity_dto.dart';
import 'package:registro_ponto_frontend/features/journey/data/repositories/journey_repository_impl.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';

class _MockRemote extends Mock implements JourneyRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late JourneyRepositoryImpl repository;

  final startedAt = DateTime.parse('2026-05-15T08:03:00-03:00').toLocal();
  final createdAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();
  final updatedAt = DateTime.parse('2026-05-15T08:03:01-03:00').toLocal();

  late JourneyDto dto;
  late Journey journey;

  setUp(() {
    remote = _MockRemote();
    repository = JourneyRepositoryImpl(remote: remote);
    dto = JourneyDto(
      id: 10,
      collaboratorId: 4,
      startedAt: startedAt,
      plannedActivities: const [
        JourneyPlannedActivityDto(
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
    journey = Journey(
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
  });

  group('fetchInProgressJourney', () {
    test('em sucesso com jornada devolve Success com a entidade', () async {
      when(() => remote.fetchInProgressJourney()).thenAnswer((_) async => dto);

      final result = await repository.fetchInProgressJourney();

      expect(result, Success<Journey?, String>(journey));
    });

    test('em sucesso sem jornada devolve Success com null', () async {
      when(() => remote.fetchInProgressJourney()).thenAnswer((_) async => null);

      final result = await repository.fetchInProgressJourney();

      expect(result, const Success<Journey?, String>(null));
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(() => remote.fetchInProgressJourney())
          .thenThrow(ApiException('Erro ao buscar jornada'));

      final result = await repository.fetchInProgressJourney();

      expect(
        result,
        const Failure<Journey?, String>('Erro ao buscar jornada'),
      );
    });
  });

  group('createUnplannedActivity', () {
    test('em sucesso devolve Success com a entidade', () async {
      final createdAt = DateTime.parse('2026-05-15T09:15:00-03:00').toLocal();
      final dto = JourneyUnplannedActivityDto(
        id: 5,
        journeyId: 10,
        description: 'Suporte urgente',
        createdAt: createdAt,
      );

      when(
        () => remote.createUnplannedActivity(
          journeyId: 10,
          description: 'Suporte urgente',
        ),
      ).thenAnswer((_) async => dto);

      final result = await repository.createUnplannedActivity(
        journeyId: 10,
        description: 'Suporte urgente',
      );

      expect(
        result,
        Success<JourneyUnplannedActivity, String>(
          JourneyUnplannedActivity(
            id: 5,
            journeyId: 10,
            description: 'Suporte urgente',
            createdAt: createdAt,
          ),
        ),
      );
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(
        () => remote.createUnplannedActivity(
          journeyId: 10,
          description: 'x',
        ),
      ).thenThrow(ApiException('Jornada encerrada'));

      final result = await repository.createUnplannedActivity(
        journeyId: 10,
        description: 'x',
      );

      expect(
        result,
        const Failure<JourneyUnplannedActivity, String>('Jornada encerrada'),
      );
    });
  });

  group('deleteUnplannedActivity', () {
    test('em sucesso devolve Success com o id removido', () async {
      when(() => remote.deleteUnplannedActivity(id: 5)).thenAnswer((_) async {});

      final result = await repository.deleteUnplannedActivity(id: 5);

      expect(result, const Success<int, String>(5));
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(() => remote.deleteUnplannedActivity(id: 99))
          .thenThrow(ApiException('Não encontrado'));

      final result = await repository.deleteUnplannedActivity(id: 99);

      expect(result, const Failure<int, String>('Não encontrado'));
    });
  });

  group('updatePlannedActivityChecked', () {
    test('em sucesso devolve Success com a entidade atualizada', () async {
      final updatedDto = JourneyPlannedActivityDto(
        id: 1,
        plannedActivityId: 7,
        description: 'Ajustar API de login',
        checked: false,
      );

      when(
        () => remote.updatePlannedActivityChecked(
          id: 1,
          checked: false,
        ),
      ).thenAnswer((_) async => updatedDto);

      final result = await repository.updatePlannedActivityChecked(
        journeyPlannedActivityId: 1,
        checked: false,
      );

      expect(
        result,
        Success<JourneyPlannedActivity, String>(
          JourneyPlannedActivity(
            id: 1,
            plannedActivityId: 7,
            description: 'Ajustar API de login',
            checked: false,
          ),
        ),
      );
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(
        () => remote.updatePlannedActivityChecked(
          id: 99,
          checked: true,
        ),
      ).thenThrow(ApiException('Atividade não encontrada'));

      final result = await repository.updatePlannedActivityChecked(
        journeyPlannedActivityId: 99,
        checked: true,
      );

      expect(
        result,
        const Failure<JourneyPlannedActivity, String>('Atividade não encontrada'),
      );
    });
  });

  group('startJourney', () {
    test('em sucesso devolve Success com a entidade da jornada', () async {
      when(() => remote.startJourney()).thenAnswer((_) async => dto);

      final result = await repository.startJourney();

      expect(result, Success<Journey, String>(journey));
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(() => remote.startJourney()).thenThrow(ApiException('Jornada já em andamento'));

      final result = await repository.startJourney();

      expect(result, const Failure<Journey, String>('Jornada já em andamento'));
    });
  });
}
