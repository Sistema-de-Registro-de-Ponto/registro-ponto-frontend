import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/features/manager/data/datasources/manager_remote_data_source_impl.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late ManagerRemoteDataSourceImpl dataSource;

  const overviewJson = <String, dynamic>{
    'duration_seconds': 247_500,
    'journeys_progress': 5,
    'average_adherence_percentage': 87,
    'activities_completed': 32,
    'unplanned_activities': 8,
  };

  setUp(() {
    dio = _MockDio();
    dataSource = ManagerRemoteDataSourceImpl(dio);
  });

  test(
    'fetchOverview chama GET /v1/manager/overview com startDate e end_date',
    () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/overview',
          queryParameters: <String, dynamic>{
            'start_date': '2026-05-17',
            'end_date': '2026-05-17',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: overviewJson,
          requestOptions: RequestOptions(path: '/v1/manager/overview'),
        ),
      );

      final dto = await dataSource.fetchOverview(
        startDate: DateTime(2026, 5, 17),
        endDate: DateTime(2026, 5, 17),
      );

      expect(dto.durationSeconds, 247_500);
      expect(dto.journeysInProgress, 5);
      verify(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/overview',
          queryParameters: <String, dynamic>{
            'start_date': '2026-05-17',
            'end_date': '2026-05-17',
          },
        ),
      ).called(1);
    },
  );

  test(
    'fetchCollaborators chama GET /v1/manager/collaborators com page, size e search',
    () async {
      const pageJson = <String, dynamic>{
        'content': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 1,
            'first_name': 'Maria',
            'current_journey_status': 'in_progress',
            'hours_today_seconds': 8100,
            'adherence_percentage': 95,
          },
        ],
        'number': 0,
        'size': 10,
        'totalElements': 1,
        'first': true,
        'last': true,
        'empty': false,
      };

      when(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/collaborators',
          queryParameters: <String, dynamic>{
            'page': 0,
            'size': 10,
            'search': 'maria',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: pageJson,
          requestOptions: RequestOptions(path: '/v1/manager/collaborators'),
        ),
      );

      final dto = await dataSource.fetchCollaborators(
        page: 0,
        pageSize: 10,
        query: 'maria',
      );

      expect(dto.content.first.firstName, 'Maria');
      verify(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/collaborators',
          queryParameters: <String, dynamic>{
            'page': 0,
            'size': 10,
            'search': 'maria',
          },
        ),
      ).called(1);
    },
  );

  test(
    'fetchJourneys chama GET /v1/manager/journeys com page e size',
    () async {
      const pageJson = <String, dynamic>{
        'content': <Map<String, dynamic>>[
          <String, dynamic>{
            'id': 42,
            'journey_date': '2025-05-14',
            'collaborator_id': 1,
            'collaborator_first_name': 'Maria Silva',
            'started_at': '2025-05-14T08:03:00-03:00',
            'ended_at': null,
            'duration_seconds': 8460,
            'status': 'in_progress',
          },
        ],
        'number': 0,
        'size': 10,
        'totalElements': 25,
        'first': true,
        'last': false,
        'empty': false,
      };

      when(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/journeys',
          queryParameters: <String, dynamic>{'page': 0, 'size': 10},
        ),
      ).thenAnswer(
        (_) async => Response(
          data: pageJson,
          requestOptions: RequestOptions(path: '/v1/manager/journeys'),
        ),
      );

      final dto = await dataSource.fetchJourneys(page: 0, pageSize: 10);

      expect(dto.content.first.collaboratorFirstName, 'Maria Silva');
      verify(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/journeys',
          queryParameters: <String, dynamic>{'page': 0, 'size': 10},
        ),
      ).called(1);
    },
  );

  test(
    'fetchJourneys envia período e collaborator_name quando informados',
    () async {
      const pageJson = <String, dynamic>{
        'content': <Map<String, dynamic>>[],
        'number': 0,
        'size': 10,
        'totalElements': 0,
        'first': true,
        'last': true,
        'empty': true,
      };

      when(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/journeys',
          queryParameters: <String, dynamic>{
            'page': 0,
            'size': 10,
            'start_date': '2025-05-01',
            'end_date': '2025-05-14',
            'collaborator_name': 'Maria',
          },
        ),
      ).thenAnswer(
        (_) async => Response(
          data: pageJson,
          requestOptions: RequestOptions(path: '/v1/manager/journeys'),
        ),
      );

      await dataSource.fetchJourneys(
        page: 0,
        pageSize: 10,
        startDate: DateTime(2025, 5, 1),
        endDate: DateTime(2025, 5, 14),
        collaboratorName: 'Maria',
      );

      verify(
        () => dio.get<Map<String, dynamic>>(
          '/v1/manager/journeys',
          queryParameters: <String, dynamic>{
            'page': 0,
            'size': 10,
            'start_date': '2025-05-01',
            'end_date': '2025-05-14',
            'collaborator_name': 'Maria',
          },
        ),
      ).called(1);
    },
  );
}
