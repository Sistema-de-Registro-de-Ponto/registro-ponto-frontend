import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:registro_ponto_frontend/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/login_response_dto.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/persisted_auth_session_dto.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/user_dto.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user.dart';

class _MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class _MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class _FakePersistedAuthSessionDto extends Fake implements PersistedAuthSessionDto {}

void main() {
  late _MockAuthRemoteDataSource remote;
  late _MockAuthLocalDataSource local;
  late AuthRepositoryImpl repository;

  const username = 'colaborador';
  const password = '12345678';
  const token = 'jwt.payload.signature';
  const tokenType = 'Bearer';
  const loginDto = LoginResponseDto(token: token, tokenType: tokenType);
  const userDto = UserDto(username: username, roles: ['ROLE_COLLABORATOR']);
  const expectedUser = User(username: username, roles: ['ROLE_COLLABORATOR']);
  const expectedSession = AuthSession(token: token, tokenType: tokenType, user: expectedUser);
  const persistedDto = PersistedAuthSessionDto(
    token: token,
    tokenType: tokenType,
    username: username,
    roles: ['ROLE_COLLABORATOR'],
  );

  setUpAll(() {
    registerFallbackValue(_FakePersistedAuthSessionDto());
  });

  setUp(() {
    remote = _MockAuthRemoteDataSource();
    local = _MockAuthLocalDataSource();
    repository = AuthRepositoryImpl(remote: remote, local: local);
  });

  group('login', () {
    test('em sucesso, devolve Success(AuthSession) e persiste a sessão', () async {
      when(() => remote.login(username: username, password: password)).thenAnswer((_) async => loginDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenAnswer((_) async => userDto);
      when(() => local.save(any())).thenAnswer((_) async {});

      final result = await repository.login(username: username, password: password);

      expect(result, const Success<AuthSession, String>(expectedSession));
      final captured = verify(() => local.save(captureAny())).captured.single as PersistedAuthSessionDto;
      expect(captured.toEntity(), expectedSession);
    });

    test('em ApiException no login devolve Failure com a mensagem e não persiste', () async {
      when(
        () => remote.login(username: username, password: password),
      ).thenThrow(ApiException('Credenciais inválidas'));

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, String>('Credenciais inválidas'));
      verifyNever(
        () => remote.getMe(
          token: any(named: 'token'),
          tokenType: any(named: 'tokenType'),
        ),
      );
      verifyNever(() => local.save(any()));
    });

    test('em ApiException de rede devolve Failure com a mensagem', () async {
      when(() => remote.login(username: username, password: password)).thenThrow(ApiException('Erro na conexão'));

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, String>('Erro na conexão'));
    });

    test('em ApiException genérica devolve Failure com a mensagem', () async {
      when(() => remote.login(username: username, password: password)).thenThrow(ApiException('Serviço indisponível'));

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, String>('Serviço indisponível'));
    });

    test('quando login OK mas getMe lança ApiException, devolve Failure com a mensagem e não persiste', () async {
      when(() => remote.login(username: username, password: password)).thenAnswer((_) async => loginDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenThrow(ApiException('Sessão inválida'));

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, String>('Sessão inválida'));
      verifyNever(() => local.save(any()));
    });

    test('quando login OK mas getMe lança erro genérico, devolve Failure com toString e não persiste', () async {
      when(() => remote.login(username: username, password: password)).thenAnswer((_) async => loginDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenThrow(Exception('falha inesperada'));

      final result = await repository.login(username: username, password: password);

      expect(result, isA<Failure<AuthSession, String>>());
      expect((result as Failure<AuthSession, String>).error, 'Exception: falha inesperada');
      verifyNever(() => local.save(any()));
    });
  });

  group('fetchCurrentUser', () {
    test('sem sessão persistida devolve Failure com mensagem fixa', () async {
      when(() => local.read()).thenAnswer((_) async => null);

      final result = await repository.fetchCurrentUser();

      expect(result, const Failure<User, String>('Não autorizado'));
      verifyNever(
        () => remote.getMe(
          token: any(named: 'token'),
          tokenType: any(named: 'tokenType'),
        ),
      );
    });

    test('com sessão persistida e 200, devolve Success(User)', () async {
      when(() => local.read()).thenAnswer((_) async => persistedDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenAnswer((_) async => userDto);

      final result = await repository.fetchCurrentUser();

      expect(result, const Success<User, String>(expectedUser));
    });

    test('com sessão persistida e ApiException, devolve Failure com a mensagem', () async {
      when(() => local.read()).thenAnswer((_) async => persistedDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenThrow(ApiException('Token expirado'));

      final result = await repository.fetchCurrentUser();

      expect(result, const Failure<User, String>('Token expirado'));
    });
  });

  group('loadPersistedSession', () {
    test('sem nada salvo devolve null', () async {
      when(() => local.read()).thenAnswer((_) async => null);

      expect(await repository.loadPersistedSession(), isNull);
    });

    test('com sessão salva devolve a entidade AuthSession reconstruída', () async {
      when(() => local.read()).thenAnswer((_) async => persistedDto);

      final session = await repository.loadPersistedSession();

      expect(session, expectedSession);
    });
  });

  group('logout', () {
    test('delega clear() ao local data source', () async {
      when(() => local.clear()).thenAnswer((_) async {});

      await repository.logout();

      verify(() => local.clear()).called(1);
    });
  });
}
