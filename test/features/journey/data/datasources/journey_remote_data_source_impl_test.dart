import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/features/journey/data/datasources/journey_remote_data_source_impl.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_status.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late JourneyRemoteDataSourceImpl dataSource;

  final journeyJson = <String, dynamic>{
    'id': 10,
    'collaborator_id': 4,
    'started_at': '2026-05-15T08:03:00-03:00',
    'journey_planned_activities': <Map<String, dynamic>>[],
    'status': 'in_progress',
    'created_at': '2026-05-15T08:03:01-03:00',
    'updated_at': '2026-05-15T08:03:01-03:00',
  };

  final completedJson = <String, dynamic>{
    ...journeyJson,
    'status': 'completed',
    'ended_at': '2026-05-15T17:30:00-03:00',
    'duration_seconds': 28_800,
    'summary': 'Dia produtivo.',
    'updated_at': '2026-05-15T17:30:01-03:00',
  };

  setUp(() {
    dio = _MockDio();
    dataSource = JourneyRemoteDataSourceImpl(dio);
  });

  group('startJourney', () {
    test('chama POST /v1/journeys/start e mapeia resposta na raiz', () async {
      when(
        () => dio.post<Map<String, dynamic>>('/v1/journeys/start'),
      ).thenAnswer(
        (_) async => Response(
          data: journeyJson,
          requestOptions: RequestOptions(path: '/v1/journeys/start'),
        ),
      );

      final dto = await dataSource.startJourney();

      expect(dto.id, 10);
      expect(dto.status, JourneyStatus.inProgress);
      verify(() => dio.post<Map<String, dynamic>>('/v1/journeys/start')).called(1);
    });

    test('aceita resposta com jornada em journey', () async {
      when(
        () => dio.post<Map<String, dynamic>>('/v1/journeys/start'),
      ).thenAnswer(
        (_) async => Response(
          data: <String, dynamic>{'journey': journeyJson},
          requestOptions: RequestOptions(path: '/v1/journeys/start'),
        ),
      );

      final dto = await dataSource.startJourney();

      expect(dto.id, 10);
    });
  });

  group('endCurrentJourney', () {
    test('chama POST /v1/journeys/current/end com summary e mapeia jornada', () async {
      when(
        () => dio.post<Map<String, dynamic>>(
          '/v1/journeys/current/end',
          data: <String, dynamic>{'summary': 'Dia produtivo.'},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: completedJson,
          requestOptions: RequestOptions(path: '/v1/journeys/current/end'),
        ),
      );

      final dto = await dataSource.endCurrentJourney(summary: 'Dia produtivo.');

      expect(dto.status, JourneyStatus.completed);
      expect(dto.summary, 'Dia produtivo.');
      expect(dto.duration, const Duration(hours: 8));
      verify(
        () => dio.post<Map<String, dynamic>>(
          '/v1/journeys/current/end',
          data: <String, dynamic>{'summary': 'Dia produtivo.'},
        ),
      ).called(1);
    });
  });
}
