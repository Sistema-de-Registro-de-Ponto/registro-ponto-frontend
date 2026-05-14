import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/auth_repository_provider.dart';
import '../../domain/entities/auth_session.dart';

part 'auth_session_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthSessionController extends _$AuthSessionController {
  @override
  Future<AuthSession?> build() {
    return ref.read(authRepositoryProvider).loadPersistedSession();
  }

  void setSession(AuthSession session) {
    state = AsyncData(session);
  }

  Future<void> clear() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}
