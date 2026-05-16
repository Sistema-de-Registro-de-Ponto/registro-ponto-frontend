import 'package:registro_ponto_frontend/core/extensions/object_extensions.dart';
import 'package:registro_ponto_frontend/core/network/api_exception.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_page.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/repositories/journey_repository.dart';

import '../datasources/journey_remote_data_source.dart';

class JourneyRepositoryImpl implements JourneyRepository {
  final JourneyRemoteDataSource _remote;

  JourneyRepositoryImpl({required JourneyRemoteDataSource remote})
    : _remote = remote;

  @override
  Future<Result<JourneyPage, String>> fetchJourneys({
    required DateTime startDate,
    required DateTime endDate,
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final dto = await _remote.fetchJourneys(
        startDate: startDate,
        endDate: endDate,
        page: page,
        pageSize: pageSize,
      );
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
    }
  }

  @override
  Future<Result<Journey?, String>> fetchInProgressJourney() async {
    try {
      final dto = await _remote.fetchInProgressJourney();
      return Success(dto?.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
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
      return Failure(e.toErrorString());
    }
  }

  @override
  Future<Result<Journey, String>> endJourney({required String summary}) async {
    try {
      final dto = await _remote.endCurrentJourney(summary: summary);
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
    }
  }

  @override
  Future<Result<JourneyPlannedActivity, String>> updatePlannedActivityChecked({
    required int journeyPlannedActivityId,
    required bool checked,
  }) async {
    try {
      final dto = await _remote.updatePlannedActivityChecked(
        id: journeyPlannedActivityId,
        checked: checked,
      );
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
    }
  }

  @override
  Future<Result<JourneyUnplannedActivity, String>> createUnplannedActivity({
    required int journeyId,
    required String description,
  }) async {
    try {
      final dto = await _remote.createUnplannedActivity(
        journeyId: journeyId,
        description: description,
      );
      return Success(dto.toEntity());
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
    }
  }

  @override
  Future<Result<int, String>> deleteUnplannedActivity({required int id}) async {
    try {
      await _remote.deleteUnplannedActivity(id: id);
      return Success(id);
    } on ApiException catch (e) {
      return Failure(e.message);
    } catch (e) {
      return Failure(e.toErrorString());
    }
  }
}
