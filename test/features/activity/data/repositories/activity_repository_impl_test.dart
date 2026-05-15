import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/activity/data/datasources/activity_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/activity/data/models/planned_activity_dto.dart';
import 'package:registro_ponto_frontend/features/activity/data/repositories/activity_repository_impl.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';

class _MockRemote extends Mock implements ActivityRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late ActivityRepositoryImpl repository;

  final createdAt = DateTime.parse(
    '2026-05-15T12:08:22.904747-03:00',
  ).toLocal();
  late PlannedActivityDto dto;
  late PlannedActivity activity;

  setUp(() {
    remote = _MockRemote();
    repository = ActivityRepositoryImpl(remote: remote);
    dto = PlannedActivityDto(
      id: 1,
      description: 'Planejamento sprint',
      createdAt: createdAt,
    );
    activity = PlannedActivity(
      id: 1,
      description: 'Planejamento sprint',
      createdAt: createdAt,
    );
  });

  group('fetchPlannedActivities', () {
    test('em sucesso devolve Success com lista de entidades', () async {
      when(
        () => remote.fetchPlannedActivities(),
      ).thenAnswer((_) async => [dto]);

      final result = await repository.fetchPlannedActivities();

      expect(result, Success<List<PlannedActivity>, String>([activity]));
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(
        () => remote.fetchPlannedActivities(),
      ).thenThrow(ApiException('Lista indisponível'));

      final result = await repository.fetchPlannedActivities();

      expect(
        result,
        const Failure<List<PlannedActivity>, String>('Lista indisponível'),
      );
    });
  });

  group('createPlannedActivity', () {
    test('em sucesso devolve Success com a entidade criada', () async {
      when(
        () => remote.createPlannedActivity(description: 'Nova tarefa'),
      ).thenAnswer((_) async => dto);

      final result = await repository.createPlannedActivity(
        description: 'Nova tarefa',
      );

      expect(result, Success<PlannedActivity, String>(activity));
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(
        () => remote.createPlannedActivity(description: 'x'),
      ).thenThrow(ApiException('Descrição inválida'));

      final result = await repository.createPlannedActivity(description: 'x');

      expect(
        result,
        const Failure<PlannedActivity, String>('Descrição inválida'),
      );
    });
  });

  group('deletePlannedActivity', () {
    test('em sucesso devolve Success com a entidade removida', () async {
      when(
        () => remote.deletePlannedActivity(id: 1),
      ).thenAnswer((_) async => dto);

      final result = await repository.deletePlannedActivity(id: 1);

      expect(result, Success<PlannedActivity, String>(activity));
    });

    test('em ApiException devolve Failure com a mensagem', () async {
      when(
        () => remote.deletePlannedActivity(id: 99),
      ).thenThrow(ApiException('Não encontrada'));

      final result = await repository.deletePlannedActivity(id: 99);

      expect(result, const Failure<PlannedActivity, String>('Não encontrada'));
    });
  });
}
