import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';

import '../datasources/journey_remote_data_source.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  final JourneyRemoteDataSource _remote;

  JourneyRepositoryImpl({required JourneyRemoteDataSource remote}) : _remote = remote;

  @override
  Future<Result<Journey?, String>> fetchInProgressJourney() async {
    try {
      final dto = await _remote.fetchInProgressJourney();
      return Success(dto?.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<Journey, String>> startJourney() async {
    try {
      final dto = await _remote.startJourney();
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }

  @override
  Future<Result<JourneyPlannedActivity, String>> updatePlannedActivityChecked({
    required int journeyPlannedActivityId,
    required bool checked,
  }) async {
    try {
      final dto = await _remote.updatePlannedActivityChecked(
        journeyPlannedActivityId: journeyPlannedActivityId,
        checked: checked,
      );
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toString());
    }
  }
}
