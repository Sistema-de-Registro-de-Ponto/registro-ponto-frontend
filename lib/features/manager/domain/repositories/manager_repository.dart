import 'package:registro_ponto_frontend/core/utils/result.dart';

import '../entities/manager_overview.dart';
import '../entities/manager_profile.dart';

abstract class ManagerRepository {
  Future<Result<ManagerProfile, String>> fetchProfile();

  Future<Result<ManagerOverview, String>> fetchOverview({
    required DateTime startDate,
    required DateTime endDate,
  });
}
