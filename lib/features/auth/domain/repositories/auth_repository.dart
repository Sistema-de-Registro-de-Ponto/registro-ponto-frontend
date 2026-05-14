import '../../../../core/utils/result.dart';
import '../entities/auth_session.dart';
import '../entities/user.dart';
import '../failures/auth_failure.dart';

abstract interface class AuthRepository {
  Future<Result<AuthSession, AuthFailure>> login({
    required String username,
    required String password,
  });

  Future<Result<User, AuthFailure>> fetchCurrentUser();

  Future<AuthSession?> loadPersistedSession();

  Future<void> logout();
}
