import '../models/persisted_auth_session_dto.dart';

abstract interface class AuthLocalDataSource {
  Future<void> save(PersistedAuthSessionDto session);
  Future<PersistedAuthSessionDto?> read();
  Future<void> clear();
}
