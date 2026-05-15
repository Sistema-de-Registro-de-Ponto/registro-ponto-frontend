import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession, String>> login({
    required String username,
    required String password,
  });

  Future<AuthSession?> loadPersistedSession();

  Future<void> logout();
}
