import 'package:registro_ponto_frontend/core/network/api_exception.dart';

import '../../../../core/utils/result.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/login_response_dto.dart';
import '../models/persisted_auth_session_dto.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  const AuthRepositoryImpl({required AuthRemoteDataSource remote, required AuthLocalDataSource local})
    : _remote = remote,
      _local = local;

  @override
  Future<Result<AuthSession, String>> login({required String username, required String password}) async {
    final LoginResponseDto loginDto;
    try {
      loginDto = await _remote.login(username: username, password: password);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }

    try {
      final userDto = await _remote.getMe(token: loginDto.token, tokenType: loginDto.tokenType);
      final session = AuthSession(token: loginDto.token, tokenType: loginDto.tokenType, user: userDto.toEntity());

      await _local.save(PersistedAuthSessionDto.fromEntity(session));
      return Success(session);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<User, String>> fetchCurrentUser() async {
    final stored = await _local.read();
    if (stored == null) return const Failure('Não autorizado');

    try {
      final userDto = await _remote.getMe(token: stored.token, tokenType: stored.tokenType);
      return Success(userDto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<AuthSession?> loadPersistedSession() async {
    final stored = await _local.read();
    return stored?.toEntity();
  }

  @override
  Future<void> logout() => _local.clear();
}
