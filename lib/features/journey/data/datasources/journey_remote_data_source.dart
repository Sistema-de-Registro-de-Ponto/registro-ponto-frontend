import '../models/journey_dto.dart';
import '../models/journey_planned_activity_dto.dart';
import '../models/journey_unplanned_activity_dto.dart';

abstract class JourneyRemoteDataSource {
  Future<JourneyDto?> fetchInProgressJourney();

  Future<JourneyDto> startJourney();

  Future<JourneyPlannedActivityDto> updatePlannedActivityChecked({
    required int id,
    required bool checked,
  });

  Future<JourneyUnplannedActivityDto> createUnplannedActivity({
    required int journeyId,
    required String description,
  });

  Future<void> deleteUnplannedActivity({required int id});
}
