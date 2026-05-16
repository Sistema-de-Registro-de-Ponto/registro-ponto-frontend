import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_page.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_planned_activity.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey_unplanned_activity.dart';

abstract class JourneyRepository {
  Future<Result<JourneyPage, String>> fetchJourneys({
    required DateTime startDate,
    required DateTime endDate,
    int page = 0,
    int pageSize = 20,
  });

  Future<Result<Journey?, String>> fetchInProgressJourney();

  Future<Result<Journey, String>> startJourney();

  Future<Result<Journey, String>> endJourney({required String summary});

  Future<Result<JourneyPlannedActivity, String>> updatePlannedActivityChecked({
    required int journeyPlannedActivityId,
    required bool checked,
  });

  Future<Result<JourneyUnplannedActivity, String>> createUnplannedActivity({
    required int journeyId,
    required String description,
  });

  Future<Result<int, String>> deleteUnplannedActivity({required int id});
}
