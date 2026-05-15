import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';
import 'package:registro_ponto_frontend/features/activity/domain/repositories/activity_repository.dart';

import '../datasources/activity_remote_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource _remote;

  ActivityRepositoryImpl({required ActivityRemoteDataSource remote}) : _remote = remote;

  @override
  Future<Result<List<PlannedActivity>, String>> fetchPlannedActivities() async {
    try {
      final dtos = await _remote.fetchPlannedActivities();
      return Success(dtos.map((dto) => dto.toEntity()).toList());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<PlannedActivity, String>> createPlannedActivity({required String description}) async {
    try {
      final dto = await _remote.createPlannedActivity(description: description);
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<PlannedActivity, String>> deletePlannedActivity({required int id}) async {
    try {
      final dto = await _remote.deletePlannedActivity(id: id);
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
