import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/collaborator/data/datasources/collaborator_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/collaborator/data/models/collaborator_profile_dto.dart';
import 'package:registro_ponto_frontend/features/collaborator/data/repositories/collaborator_repository_impl.dart';
import 'package:registro_ponto_frontend/features/collaborator/domain/entities/collaborator_profile.dart';

class _MockRemote extends Mock implements CollaboratorRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late CollaboratorRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = CollaboratorRepositoryImpl(remote: remote);
  });

  test('fetchProfile em sucesso devolve Success(CollaboratorProfile)', () async {
    when(() => remote.fetchProfile()).thenAnswer(
      (_) async => const CollaboratorProfileDto(userId: 1, firstName: 'Ana'),
    );

    final result = await repository.fetchProfile();

    expect(
      result,
      const Success<CollaboratorProfile, String>(
        CollaboratorProfile(userId: 1, firstName: 'Ana'),
      ),
    );
  });

  test('fetchProfile em ApiException devolve Failure com a mensagem', () async {
    when(() => remote.fetchProfile()).thenThrow(ApiException('Perfil indisponível'));

    final result = await repository.fetchProfile();

    expect(result, const Failure<CollaboratorProfile, String>('Perfil indisponível'));
  });

  test('fetchProfile em erro genérico devolve Failure com toString', () async {
    when(() => remote.fetchProfile()).thenThrow(Exception('oops'));

    final result = await repository.fetchProfile();

    expect(result, isA<Failure<CollaboratorProfile, String>>());
    expect((result as Failure<CollaboratorProfile, String>).error, 'Exception: oops');
  });
}
