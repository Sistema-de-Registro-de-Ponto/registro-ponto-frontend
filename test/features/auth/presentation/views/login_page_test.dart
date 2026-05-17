import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user_role.dart';
import 'package:registro_ponto_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/views/login_page.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

Widget _harness(AuthRepository repo) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/', builder: (_, _) => const Placeholder()),
    ],
  );
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp.router(routerConfig: router),
  );
}

Finder _input(String keyValue) => find.descendant(
  of: find.byKey(ValueKey(keyValue)),
  matching: find.byType(TextFormField),
);

void main() {
  late _MockAuthRepository repo;

  setUp(() {
    repo = _MockAuthRepository();
  });

  testWidgets('exibe erro de validação ao submeter campos vazios', (
    tester,
  ) async {
    await tester.pumpWidget(_harness(repo));

    await tester.tap(find.byKey(const ValueKey('login.submit')));
    await tester.pump();

    expect(find.text('Informe o usuário'), findsOneWidget);
    expect(find.text('Informe a senha'), findsOneWidget);
    verifyNever(
      () => repo.login(
        username: any(named: 'username'),
        password: any(named: 'password'),
      ),
    );
  });

  testWidgets('submete credenciais ao tocar em Entrar', (tester) async {
    when(
      () => repo.login(username: 'colaborador', password: '12345678'),
    ).thenAnswer(
      (_) async => const Success<AuthSession, String>(
        AuthSession(token: 't', tokenType: 'Bearer', role: UserRole.collaborator),
      ),
    );

    await tester.pumpWidget(_harness(repo));

    await tester.enterText(_input('login.username'), 'colaborador');
    await tester.enterText(_input('login.password'), '12345678');
    await tester.tap(find.byKey(const ValueKey('login.submit')));
    await tester.pump();

    verify(
      () => repo.login(username: 'colaborador', password: '12345678'),
    ).called(1);
  });

  testWidgets('mostra mensagem amigável quando login falha com 401', (
    tester,
  ) async {
    when(
      () => repo.login(username: 'colaborador', password: 'wrong'),
    ).thenAnswer(
      (_) async =>
          const Failure<AuthSession, String>('Usuário ou senha inválidos.'),
    );

    await tester.pumpWidget(_harness(repo));

    await tester.enterText(_input('login.username'), 'colaborador');
    await tester.enterText(_input('login.password'), 'wrong');
    await tester.tap(find.byKey(const ValueKey('login.submit')));
    await tester.pumpAndSettle();

    expect(find.text('Usuário ou senha inválidos.'), findsOneWidget);
  });

  testWidgets('desabilita o botão e troca por spinner enquanto carrega', (
    tester,
  ) async {
    when(
      () => repo.login(username: 'colaborador', password: '12345678'),
    ).thenAnswer(
      (_) => Future.delayed(
        const Duration(milliseconds: 200),
        () => const Success<AuthSession, String>(
          AuthSession(token: 't', tokenType: 'Bearer', role: UserRole.collaborator),
        ),
      ),
    );

    await tester.pumpWidget(_harness(repo));

    await tester.enterText(_input('login.username'), 'colaborador');
    await tester.enterText(_input('login.password'), '12345678');
    await tester.tap(find.byKey(const ValueKey('login.submit')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
  });
}
