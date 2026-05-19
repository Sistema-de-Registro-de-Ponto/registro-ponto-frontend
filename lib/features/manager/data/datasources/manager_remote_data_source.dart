import 'package:registro_ponto_frontend/features/journey/data/models/journey_dto.dart';

import '../../../../core/pagination/page_dto.dart';
import '../models/manager_collaborator_detail_dto.dart';
import '../models/manager_collaborator_dto.dart';
import '../models/manager_consolidated_report_dto.dart';
import '../models/manager_journey_list_item_dto.dart';
import '../models/manager_overview_dto.dart';
import '../models/manager_profile_dto.dart';
import '../models/manager_rpa_record_dto.dart';

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

  Future<PageDto<ManagerJourneyListItemDto>> fetchJourneys({
    required int page,
    required int pageSize,
    DateTime? startDate,
    DateTime? endDate,
    String? collaboratorName,
  });

  Future<JourneyDto> fetchJourneyById(int id);

  Future<ManagerConsolidatedReportDto> fetchConsolidatedReport({
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
    String? search,
  });

  Future<PageDto<ManagerRpaRecordDto>> fetchRpaRecords({
    required int page,
    required int pageSize,
    DateTime? startDate,
    DateTime? endDate,
    String? search,
  });
}
