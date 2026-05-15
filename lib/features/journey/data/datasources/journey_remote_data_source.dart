import '../models/journey_dto.dart';

abstract class JourneyRemoteDataSource {
  Future<JourneyDto?> fetchInProgressJourney();

  Future<JourneyDto> startJourney();
}
