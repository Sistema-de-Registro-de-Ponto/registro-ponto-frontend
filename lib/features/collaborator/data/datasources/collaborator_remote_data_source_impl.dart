import 'package:dio/dio.dart';

import '../../../../core/network/api_exception.dart';
import '../models/collaborator_profile_dto.dart';
import 'collaborator_remote_data_source.dart';

class CollaboratorRemoteDataSourceImpl implements CollaboratorRemoteDataSource {
  final Dio _dio;

  const CollaboratorRemoteDataSourceImpl(this._dio);

  @override
  Future<CollaboratorProfileDto> fetchProfile() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/v1/collaborator');
      return CollaboratorProfileDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
