import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/collaborator/domain/entities/collaborator_profile.dart';
import 'package:registro_ponto_frontend/features/collaborator/domain/repositories/collaborator_repository.dart';

import '../datasources/collaborator_remote_data_source.dart';

class CollaboratorRepositoryImpl implements CollaboratorRepository {
  final CollaboratorRemoteDataSource _remote;

  CollaboratorRepositoryImpl({required CollaboratorRemoteDataSource remote}) : _remote = remote;

  @override
  Future<Result<CollaboratorProfile, String>> fetchProfile() async {
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
