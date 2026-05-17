import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user_role.dart';
import 'package:registro_ponto_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/login_state.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/login_view_model.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repo;
  late ProviderContainer container;

  const username = 'colaborador';
  const password = '12345678';
  const session = AuthSession(token: 't', tokenType: 'Bearer', role: UserRole.collaborator);

  LoginViewModel notifier() => container.read(loginViewModelProvider.notifier);
  LoginState readState() => container.read(loginViewModelProvider);

  setUp(() {
    repo = _MockAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repo)],
    );
    addTearDown(container.dispose);
  });

  test('inicia com LoginState default (campos vazios, idle)', () {
    expect(readState(), const LoginState());
  });

  test('setUsername e setPassword atualizam o state', () {
    notifier().setUsername('colaborador');
    notifier().setPassword('12345678');

    expect(readState().username, 'colaborador');
    expect(readState().password, '12345678');
  });

  test('togglePasswordVisibility alterna o flag', () {
    expect(readState().passwordVisible, isFalse);

    notifier().togglePasswordVisibility();
    expect(readState().passwordVisible, isTrue);

    notifier().togglePasswordVisibility();
    expect(readState().passwordVisible, isFalse);
  });

  test(
    'submit em sucesso transita isLoading=true -> isLoading=false sem failure',
    () async {
      when(
        () => repo.login(username: username, password: password),
      ).thenAnswer((_) async => const Success<AuthSession, String>(session));

      notifier().setUsername(username);
      notifier().setPassword(password);

      final future = notifier().submit();
      expect(readState().isLoading, isTrue);

      await future;
      expect(readState().isLoading, isFalse);
      expect(readState().failure, isNull);
    },
  );

  test('submit com Failure preenche failure no state com a string', () async {
    when(() => repo.login(username: username, password: password)).thenAnswer(
      (_) async => const Failure<AuthSession, String>('Credenciais inválidas'),
    );

    notifier().setUsername(username);
    notifier().setPassword(password);

    await notifier().submit();

    expect(readState().isLoading, isFalse);
    expect(readState().failure, 'Credenciais inválidas');
  });

  test('submit limpa a failure anterior ao iniciar nova tentativa', () async {
    when(() => repo.login(username: username, password: password)).thenAnswer(
      (_) async => const Failure<AuthSession, String>('Credenciais inválidas'),
    );

    notifier().setUsername(username);
    notifier().setPassword(password);
    await notifier().submit();
    expect(readState().failure, 'Credenciais inválidas');

    when(
      () => repo.login(username: username, password: password),
    ).thenAnswer((_) async => const Success<AuthSession, String>(session));
    final future = notifier().submit();
    expect(readState().failure, isNull);

    await future;
    expect(readState().failure, isNull);
  });

  test('usernameValidator devolve mensagem para vazio e null para válido', () {
    final vm = notifier();
    expect(vm.usernameValidator(null), 'Informe o usuário');
    expect(vm.usernameValidator(''), 'Informe o usuário');
    expect(vm.usernameValidator('colaborador'), isNull);
  });

  test('passwordValidator devolve mensagem para vazio e null para válido', () {
    final vm = notifier();
    expect(vm.passwordValidator(null), 'Informe a senha');
    expect(vm.passwordValidator(''), 'Informe a senha');
    expect(vm.passwordValidator('12345678'), isNull);
  });
}
