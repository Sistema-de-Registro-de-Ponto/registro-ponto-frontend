import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/colaborador/domain/entities/colaborador_profile.dart';
import 'package:registro_ponto_frontend/features/colaborador/domain/repositories/colaborador_repository.dart';

import '../datasources/colaborador_remote_data_source.dart';

class ColaboradorRepositoryImpl implements ColaboradorRepository {
  final ColaboradorRemoteDataSource _remote;

  ColaboradorRepositoryImpl({required ColaboradorRemoteDataSource remote}) : _remote = remote;

  @override
  Future<Result<ColaboradorProfile, String>> fetchProfile() async {
    try {
      final dto = await _remote.fetchProfile();
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
