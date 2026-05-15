import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/journey_dto.dart';
import 'journey_remote_data_source.dart';

class JourneyRemoteDataSourceImpl implements JourneyRemoteDataSource {
  static const _journeysPath = '/v1/journeys';

  final Dio _dio;

  const JourneyRemoteDataSourceImpl(this._dio);

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
      final response = await _dio.post<Map<String, dynamic>>(_journeysPath);
      final data = response.data;
      if (data == null) throw ApiException();

      return JourneyDto.fromJson(data);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
