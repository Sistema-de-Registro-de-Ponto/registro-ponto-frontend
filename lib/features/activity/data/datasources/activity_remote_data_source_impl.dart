import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/planned_activity_dto.dart';
import 'activity_remote_data_source.dart';

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final Dio _dio;

  const ActivityRemoteDataSourceImpl(this._dio);

  @override
  Future<List<PlannedActivityDto>> fetchPlannedActivities() async {
    try {
      final response = await _dio.get<List<dynamic>>('/v1/activities/planned');
      final data = response.data;
      if (data == null) return [];

      return data.whereType<Map<String, dynamic>>().map(PlannedActivityDto.fromJson).toList();
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<PlannedActivityDto> createPlannedActivity({required String description}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/activities/planned',
        data: {'description': description},
      );
      final data = response.data;
      if (data == null) throw ApiException();

      return PlannedActivityDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }

  @override
  Future<PlannedActivityDto> deletePlannedActivity({required int id}) async {
    try {
      final response = await _dio.delete<Map<String, dynamic>>('/v1/activities/planned/$id');
      final data = response.data;
      if (data == null) throw ApiException();

      return PlannedActivityDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
