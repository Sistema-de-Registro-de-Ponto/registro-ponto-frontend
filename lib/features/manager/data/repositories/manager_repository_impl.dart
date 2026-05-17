import 'package:registro_ponto_frontend/core/extensions/object_extensions.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/manager/domain/entities/manager_profile.dart';
import 'package:registro_ponto_frontend/features/manager/domain/repositories/manager_repository.dart';

import '../datasources/manager_remote_data_source.dart';

class ManagerRepositoryImpl implements ManagerRepository {
  final ManagerRemoteDataSource _remote;

  ManagerRepositoryImpl({required ManagerRemoteDataSource remote}) : _remote = remote;

  @override
  Future<Result<ManagerProfile, String>> fetchProfile() async {
    try {
      final dto = await _remote.fetchProfile();
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
    }
  }
}
