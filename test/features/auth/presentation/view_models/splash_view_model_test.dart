import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user_role.dart';
import 'package:registro_ponto_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_destination.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_min_display_duration.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_view_model.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repo;
  late ProviderContainer container;

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
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        splashMinDisplayDurationProvider.overrideWithValue(Duration.zero),
      ],
    );
    addTearDown(container.dispose);
  });

  test('redireciona para área do colaborador quando existe sessão COLLABORATOR', () async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => collaboratorSession);

    final destination = await container.read(splashViewModelProvider.future);

    expect(destination, SplashDestination.collaborator);
  });

  test('redireciona para área do gestor quando existe sessão MANAGER', () async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => managerSession);

    final destination = await container.read(splashViewModelProvider.future);

    expect(destination, SplashDestination.manager);
  });

  test('redireciona para login quando não existe sessão', () async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => null);

    final destination = await container.read(splashViewModelProvider.future);

    expect(destination, SplashDestination.login);
  });
}
