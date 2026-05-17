import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/app/routes.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user_role.dart';
import 'package:registro_ponto_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_min_display_duration.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/views/splash_page.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _ProbePage extends StatelessWidget {
  final String label;

  const _ProbePage({required this.label});

  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text(label)));
}

Widget _harness({
  required AuthRepository repo,
  required String initialLocation,
}) {
  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.login, builder: (_, _) => const _ProbePage(label: 'login')),
      GoRoute(path: Routes.home, builder: (_, _) => const _ProbePage(label: 'home')),
      GoRoute(
        path: Routes.management,
        builder: (_, _) => const _ProbePage(label: 'management'),
      ),
    ],
  );

  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(repo),
      splashMinDisplayDurationProvider.overrideWithValue(Duration.zero),
    ],
    child: MaterialApp.router(routerConfig: router),
  );
}

void main() {
  late _MockAuthRepository repo;

  const collaboratorSession = AuthSession(
    token: 't',
    tokenType: 'Bearer',
    role: UserRole.collaborator,
  );
  const managerSession = AuthSession(
    token: 't',
    tokenType: 'Bearer',
    role: UserRole.manager,
  );

  setUp(() {
    repo = _MockAuthRepository();
  });

  testWidgets('exibe marca e loading na splash', (tester) async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => null);

    await tester.pumpWidget(_harness(repo: repo, initialLocation: Routes.splash));
    await tester.pump();

    expect(find.byType(AppBrandLogo), findsOneWidget);
    expect(find.byType(AppLoading), findsOneWidget);
    expect(find.text('Registro de Ponto'), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets('navega para home quando há sessão COLLABORATOR', (tester) async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => collaboratorSession);

    await tester.pumpWidget(_harness(repo: repo, initialLocation: Routes.splash));
    await tester.pumpAndSettle();

    expect(find.text('home'), findsOneWidget);
  });

  testWidgets('navega para management quando há sessão MANAGER', (tester) async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => managerSession);

    await tester.pumpWidget(_harness(repo: repo, initialLocation: Routes.splash));
    await tester.pumpAndSettle();

    expect(find.text('management'), findsOneWidget);
  });

  testWidgets('navega para login sem sessão', (tester) async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => null);

    await tester.pumpWidget(_harness(repo: repo, initialLocation: Routes.splash));
    await tester.pumpAndSettle();

    expect(find.text('login'), findsOneWidget);
  });
}
