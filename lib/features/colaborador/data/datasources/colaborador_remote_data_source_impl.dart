import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/colaborador_profile_dto.dart';
import 'colaborador_remote_data_source.dart';

class ColaboradorRemoteDataSourceImpl implements ColaboradorRemoteDataSource {
  final Dio _dio;

  const ColaboradorRemoteDataSourceImpl(this._dio);

  @override
  Future<ColaboradorProfileDto> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/colaborator');
      return ColaboradorProfileDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
