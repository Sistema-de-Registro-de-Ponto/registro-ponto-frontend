import 'package:dio/dio.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/network/api_exception.dart';
import '../models/journey_dto.dart';
import '../models/journey_page_dto.dart';
import '../models/journey_planned_activity_dto.dart';
import '../models/journey_unplanned_activity_dto.dart';
import 'journey_remote_data_source.dart';

class JourneyRemoteDataSourceImpl implements JourneyRemoteDataSource {
  static const _journeysPath = '/v1/journeys';

  final Dio _dio;

  const JourneyRemoteDataSourceImpl(this._dio);

  @override
  Future<JourneyPageDto> fetchJourneys({
    required DateTime startDate,
    required DateTime endDate,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        _journeysPath,
        queryParameters: <String, dynamic>{
          'start_date': startDate.formattedApiDate,
          'end_date': endDate.formattedApiDate,
          'page': page,
          'size': pageSize,
        },
      );
      final data = response.data;
      if (data == null) throw ApiException();

      return JourneyPageDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<JourneyDto?> fetchInProgressJourney() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$_journeysPath/current',
      );
      final data = response.data;
      if (data == null) return null;

      return JourneyDto.fromJson(data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw e.mapDioException();
    }
  }

  @override
  Future<JourneyDto> startJourney() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_journeysPath/start',
      );
      final data = response.data;
      if (data == null) throw ApiException();

      return JourneyDto.fromResponseJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<JourneyDto> endCurrentJourney({required String summary}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_journeysPath/current/end',
        data: <String, dynamic>{'summary': summary},
      );
      final data = response.data;
      if (data == null) throw ApiException();

      return JourneyDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<JourneyPlannedActivityDto> updatePlannedActivityChecked({
    required int id,
    required bool checked,
  }) async {
    try {
      final response = await _dio.put<Map<String, dynamic>>(
        '$_journeysPath/activities/planned/$id',
        data: <String, dynamic>{'is_checked': checked},
      );
      final data = response.data;
      if (data == null) throw ApiException();

      return JourneyPlannedActivityDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<JourneyUnplannedActivityDto> createUnplannedActivity({
    required int journeyId,
    required String description,
  }) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$_journeysPath/$journeyId/activities/unplanned/',
        data: <String, dynamic>{'description': description},
      );
      final data = response.data;
      if (data == null) throw ApiException();

      return JourneyUnplannedActivityDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<void> deleteUnplannedActivity({required int id}) async {
    try {
      await _dio.delete<void>('$_journeysPath/activities/unplanned/$id');
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
