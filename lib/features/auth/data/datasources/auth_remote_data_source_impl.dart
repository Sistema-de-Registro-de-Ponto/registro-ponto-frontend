import 'package:dio/dio.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';

import '../models/login_response_dto.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio;

  const AuthRemoteDataSourceImpl(this._dio);

  @override
  Future<LoginResponseDto> login({required String username, required String password}) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '/v1/auth/login',
        data: {'username': username, 'password': password},
      );
      return LoginResponseDto.fromJson(response.data!);
    } on DioException catch (e) {
      throw e.mapDioException();
    }
  }
}
