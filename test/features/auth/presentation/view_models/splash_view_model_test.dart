import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_provider.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/repositories/auth_repository.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_destination.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_min_display_duration.dart';
import 'package:registro_ponto_frontend/features/auth/presentation/view_models/splash_view_model.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late _MockAuthRepository repo;
  late ProviderContainer container;

  const session = AuthSession(token: 't', tokenType: 'Bearer');

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

  test('redireciona para home quando existe sessão persistida', () async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => session);

    final destination = await container.read(splashViewModelProvider.future);

    expect(destination, SplashDestination.home);
  });

  test('redireciona para login quando não existe sessão', () async {
    when(() => repo.loadPersistedSession()).thenAnswer((_) async => null);

    final destination = await container.read(splashViewModelProvider.future);

    expect(destination, SplashDestination.login);
  });
}
