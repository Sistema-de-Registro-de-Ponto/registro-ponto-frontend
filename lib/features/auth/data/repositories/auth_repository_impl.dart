import '../../../../core/network/http_exception.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_response_dto.dart';
import '../models/persisted_auth_session_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  @override
  Future<Result<AuthSession, AuthFailure>> login({
    required String username,
    required String password,
  }) async {
    final LoginResponseDto loginDto;
    try {
      loginDto = await _remote.login(username: username, password: password);
    } on HttpException catch (e) {
      return Failure(_mapHttpFailure(e, isLoginEndpoint: true));
    } catch (e) {
      return Failure(UnknownFailure(e));
    }

    try {
      final userDto = await _remote.getMe(
        token: loginDto.token,
        tokenType: loginDto.tokenType,
      );
      final session = AuthSession(
        token: loginDto.token,
        tokenType: loginDto.tokenType,
        user: userDto.toEntity(),
      );
      await _local.save(PersistedAuthSessionDto.fromEntity(session));
      return Success(session);
    } on HttpException catch (e) {
      return Failure(_mapHttpFailure(e, isLoginEndpoint: false));
    } catch (e) {
      return Failure(UnknownFailure(e));
    }
  }

  @override
  Future<Result<User, AuthFailure>> fetchCurrentUser() async {
    final stored = await _local.read();
    if (stored == null) return const Failure(UnauthorizedFailure());

    try {
      final userDto = await _remote.getMe(
        token: stored.token,
        tokenType: stored.tokenType,
      );
      return Success(userDto.toEntity());
    } on HttpException catch (e) {
      return Failure(_mapHttpFailure(e, isLoginEndpoint: false));
    } catch (e) {
      return Failure(UnknownFailure(e));
    }
  }

  @override
  Future<AuthSession?> loadPersistedSession() async {
    final stored = await _local.read();
    return stored?.toEntity();
  }

  @override
  Future<void> logout() => _local.clear();

  AuthFailure _mapHttpFailure(
    HttpException e, {
    required bool isLoginEndpoint,
  }) {
    switch (e) {
      case NetworkException():
        return const NetworkFailure();
      case ApiException():
        if (e.statusCode == 401) {
          return isLoginEndpoint
              ? InvalidCredentialsFailure(detail: e.detail)
              : UnauthorizedFailure(detail: e.detail);
        }
        return ServerFailure(e.statusCode, detail: e.detail);
      case UnknownHttpException():
        return UnknownFailure(e.cause);
    }
  }
}
