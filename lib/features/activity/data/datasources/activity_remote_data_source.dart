import '../models/planned_activity_dto.dart';

abstract class ActivityRemoteDataSource {
  Future<List<PlannedActivityDto>> fetchPlannedActivities();

  Future<PlannedActivityDto> createPlannedActivity({required String description});

  Future<PlannedActivityDto> deletePlannedActivity({required int id});
}
