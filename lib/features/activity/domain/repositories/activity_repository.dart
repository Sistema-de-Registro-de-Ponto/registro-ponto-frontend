import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/activity/domain/entities/planned_activity.dart';

abstract class ActivityRepository {
  Future<Result<List<PlannedActivity>, String>> fetchPlannedActivities();

  Future<Result<PlannedActivity, String>> createPlannedActivity({required String description});

  Future<Result<PlannedActivity, String>> deletePlannedActivity({required int id});
}
