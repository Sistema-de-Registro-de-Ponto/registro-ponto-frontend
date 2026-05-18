import '../../../../core/pagination/page_dto.dart';
import '../models/manager_collaborator_detail_dto.dart';
import '../models/manager_collaborator_dto.dart';
import '../models/manager_overview_dto.dart';
import '../models/manager_profile_dto.dart';

abstract class ManagerRemoteDataSource {
  Future<ManagerProfileDto> fetchProfile();

  Future<ManagerOverviewDto> fetchOverview({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<PageDto<ManagerCollaboratorDto>> fetchCollaborators({
    required int page,
    required int pageSize,
    String? query,
  });

  Future<ManagerCollaboratorDetailDto> fetchCollaboratorById(int id);
}
