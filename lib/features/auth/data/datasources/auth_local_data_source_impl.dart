import 'dart:convert';

import '../../../../core/storage/secure_storage.dart';
import '../models/persisted_auth_session_dto.dart';
import 'auth_local_data_source.dart';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const _storageKey = 'auth_session';

  final SecureStorage _storage;

  const AuthLocalDataSourceImpl(this._storage);

  @override
  Future<void> save(PersistedAuthSessionDto session) {
    return _storage.write(_storageKey, jsonEncode(session.toJson()));
  }

  @override
  Future<PersistedAuthSessionDto?> read() async {
    final raw = await _storage.read(_storageKey);
    if (raw == null) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) return null;

    return PersistedAuthSessionDto.fromJson(decoded);
  }

  @override
  Future<void> clear() => _storage.delete(_storageKey);
}
