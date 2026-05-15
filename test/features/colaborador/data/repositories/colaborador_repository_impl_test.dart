import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/colaborador/data/datasources/colaborador_remote_data_source.dart';
import 'package:registro_ponto_frontend/features/colaborador/data/models/colaborador_profile_dto.dart';
import 'package:registro_ponto_frontend/features/colaborador/data/repositories/colaborador_repository_impl.dart';
import 'package:registro_ponto_frontend/features/colaborador/domain/entities/colaborador_profile.dart';

class _MockRemote extends Mock implements ColaboradorRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late ColaboradorRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = ColaboradorRepositoryImpl(remote: remote);
  });

  test('fetchProfile em sucesso devolve Success(ColaboradorProfile)', () async {
    when(() => remote.fetchProfile()).thenAnswer(
      (_) async => const ColaboradorProfileDto(userId: 1, firstName: 'Ana'),
    );

    final result = await repository.fetchProfile();

    expect(
      result,
      const Success<ColaboradorProfile, String>(
        ColaboradorProfile(userId: 1, firstName: 'Ana'),
      ),
    );
  });

  test('fetchProfile em ApiException devolve Failure com a mensagem', () async {
    when(() => remote.fetchProfile()).thenThrow(ApiException('Perfil indisponível'));

    final result = await repository.fetchProfile();

    expect(result, const Failure<ColaboradorProfile, String>('Perfil indisponível'));
  });

  test('fetchProfile em erro não-ApiException devolve Failure com toString', () async {
    when(() => remote.fetchProfile()).thenThrow(Exception('oops'));

    final result = await repository.fetchProfile();

    expect(result, isA<Failure<ColaboradorProfile, String>>());
    expect((result as Failure<ColaboradorProfile, String>).error, 'Exception: oops');
  });
}
