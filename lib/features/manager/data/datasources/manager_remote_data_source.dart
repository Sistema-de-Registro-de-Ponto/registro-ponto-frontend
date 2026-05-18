import '../models/manager_overview_dto.dart';
import '../models/manager_profile_dto.dart';

abstract class ManagerRemoteDataSource {
  Future<ManagerProfileDto> fetchProfile();

  Future<ManagerOverviewDto> fetchOverview({
    required DateTime startDate,
    required DateTime endDate,
  });
}
