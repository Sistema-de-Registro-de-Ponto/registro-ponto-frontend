import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/http_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:registro_ponto_frontend/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/login_response_dto.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/persisted_auth_session_dto.dart';
import 'package:registro_ponto_frontend/features/auth/data/models/user_dto.dart';
import 'package:registro_ponto_frontend/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/auth_session.dart';
import 'package:registro_ponto_frontend/features/auth/domain/entities/user.dart';
import 'package:registro_ponto_frontend/features/auth/domain/failures/auth_failure.dart';

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

      expect(result, const Success<AuthSession, AuthFailure>(expectedSession));
      final captured = verify(() => local.save(captureAny())).captured.single as PersistedAuthSessionDto;
      expect(captured.toEntity(), expectedSession);
    });

    test('em 401 no login devolve InvalidCredentialsFailure e não persiste', () async {
      when(
        () => remote.login(username: username, password: password),
      ).thenThrow(const ApiException(statusCode: 401, detail: 'Credenciais inválidas'));

      final result = await repository.login(username: username, password: password);

      expect(
        result,
        const Failure<AuthSession, AuthFailure>(
          InvalidCredentialsFailure(detail: 'Credenciais inválidas'),
        ),
      );
      verifyNever(
        () => remote.getMe(
          token: any(named: 'token'),
          tokenType: any(named: 'tokenType'),
        ),
      );
      verifyNever(() => local.save(any()));
    });

    test('em falha de rede devolve NetworkFailure', () async {
      when(() => remote.login(username: username, password: password)).thenThrow(const NetworkException());

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, AuthFailure>(NetworkFailure()));
    });

    test('em 5xx devolve ServerFailure com o statusCode', () async {
      when(() => remote.login(username: username, password: password)).thenThrow(const ApiException(statusCode: 503));

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, AuthFailure>(ServerFailure(503)));
    });

    test('quando login OK mas getMe falha com 401, retorna UnauthorizedFailure (não InvalidCredentials)', () async {
      when(() => remote.login(username: username, password: password)).thenAnswer((_) async => loginDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenThrow(const ApiException(statusCode: 401));

      final result = await repository.login(username: username, password: password);

      expect(result, const Failure<AuthSession, AuthFailure>(UnauthorizedFailure()));
      verifyNever(() => local.save(any()));
    });
  });

  group('fetchCurrentUser', () {
    test('sem sessão persistida devolve UnauthorizedFailure', () async {
      when(() => local.read()).thenAnswer((_) async => null);

      final result = await repository.fetchCurrentUser();

      expect(result, const Failure<User, AuthFailure>(UnauthorizedFailure()));
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

      expect(result, const Success<User, AuthFailure>(expectedUser));
    });

    test('com sessão persistida e 401, devolve UnauthorizedFailure', () async {
      when(() => local.read()).thenAnswer((_) async => persistedDto);
      when(() => remote.getMe(token: token, tokenType: tokenType)).thenThrow(const ApiException(statusCode: 401));

      final result = await repository.fetchCurrentUser();

      expect(result, const Failure<User, AuthFailure>(UnauthorizedFailure()));
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
