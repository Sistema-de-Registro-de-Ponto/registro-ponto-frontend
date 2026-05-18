import 'package:registro_ponto_frontend/core/pagination/page.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';
import 'package:registro_ponto_frontend/features/journey/domain/entities/journey.dart';

import '../entities/manager_collaborator.dart';
import '../entities/manager_collaborator_detail.dart';
import '../entities/manager_consolidated_report.dart';
import '../entities/manager_journey_list_item.dart';
import '../entities/manager_overview.dart';
import '../entities/manager_profile.dart';

abstract class ManagerRepository {
  Future<Result<ManagerProfile, String>> fetchProfile();

  Future<Result<ManagerOverview, String>> fetchOverview({
    required DateTime startDate,
    required DateTime endDate,
  });

  Future<Result<Page<ManagerCollaborator>, String>> fetchCollaborators({
    required int page,
    required int pageSize,
    String? query,
  });

  Future<Result<ManagerCollaboratorDetail, String>> fetchCollaboratorById(
    int id,
  );

  Future<Result<Page<ManagerJourneyListItem>, String>> fetchJourneys({
    required int page,
    required int pageSize,
    DateTime? startDate,
    DateTime? endDate,
    String? collaboratorName,
  });

  Future<Result<Journey, String>> fetchJourneyById(int id);

  Future<Result<ManagerConsolidatedReport, String>> fetchConsolidatedReport({
    required DateTime startDate,
    required DateTime endDate,
    required int page,
    required int pageSize,
    String? search,
  });
}
