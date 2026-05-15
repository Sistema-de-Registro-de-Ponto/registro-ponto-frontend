import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';

abstract class JourneyRepository {
  Future<Result<Journey?, String>> fetchInProgressJourney();

  Future<Result<Journey, String>> startJourney();
}
