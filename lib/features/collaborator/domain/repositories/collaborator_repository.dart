import 'package:registro_ponto_frontend/core/utils/result.dart';

import '../entities/collaborator_profile.dart';

abstract class CollaboratorRepository {
  Future<Result<CollaboratorProfile, String>> fetchProfile();
}
