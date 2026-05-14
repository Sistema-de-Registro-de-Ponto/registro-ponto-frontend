import '../models/login_response_dto.dart';
import '../models/user_dto.dart';

abstract interface class AuthRemoteDataSource {
  Future<LoginResponseDto> login({
    required String username,
    required String password,
  });

  Future<UserDto> getMe({
    required String token,
    required String tokenType,
  });
}
