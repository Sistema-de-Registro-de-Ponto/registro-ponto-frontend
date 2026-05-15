import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../entities/user.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession, String>> login({required String username, required String password});

  Future<Result<User, String>> fetchCurrentUser();

  Future<AuthSession?> loadPersistedSession();

  Future<void> logout();
}
