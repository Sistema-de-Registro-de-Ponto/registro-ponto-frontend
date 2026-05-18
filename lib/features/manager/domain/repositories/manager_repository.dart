import 'package:registro_ponto_frontend/core/pagination/page.dart';
import 'package:registro_ponto_frontend/core/utils/result.dart';

import '../entities/manager_collaborator.dart';
import '../entities/manager_collaborator_detail.dart';
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
}
