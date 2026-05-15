import '../models/login_response_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseDto> login({
    required String username,
    required String password,
  });
}
