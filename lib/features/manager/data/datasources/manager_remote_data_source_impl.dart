import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/manager_profile_dto.dart';
import 'manager_remote_data_source.dart';

class ManagerRemoteDataSourceImpl implements ManagerRemoteDataSource {
  final Dio _dio;

  const ManagerRemoteDataSourceImpl(this._dio);

  @override
  Future<ManagerProfileDto> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/manager');
      return ManagerProfileDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
