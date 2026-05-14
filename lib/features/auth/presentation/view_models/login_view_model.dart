import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/auth_repository_provider.dart';
import '../../domain/entities/auth_session.dart';
import '../../domain/failures/auth_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_session_controller.dart';
import 'login_state.dart';

part 'login_view_model.g.dart';

@riverpod
class LoginViewModel extends _$LoginViewModel {
  late final AuthRepository _authRepository = ref.read(authRepositoryProvider);
  late final AuthSessionController _authSessionController = ref.read(authSessionControllerProvider.notifier);

  @override
  LoginState build() => const LoginState();

  Future<void> submit() async {
    state = state.copyWith(isLoading: true, failure: () => null);

    final result = await _authRepository.login(username: state.username, password: state.password);

    switch (result) {
      case Success<AuthSession, AuthFailure>():
        state = state.copyWith(isLoading: false);
        _authSessionController.setSession(result.value);
      case Failure<AuthSession, AuthFailure>():
        state = state.copyWith(isLoading: false, failure: () => result.error);
    }
  }

  String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Informe o usuário';

    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Informe a senha';

    return null;
  }

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void setUsername(String value) {
    state = state.copyWith(username: value);
  }

  void setPassword(String value) {
    state = state.copyWith(password: value);
  }
}
