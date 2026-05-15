import 'package:registro_ponto_frontend/core/utils/result.dart';

import '../entities/colaborador_profile.dart';

abstract class ColaboradorRepository {
  Future<Result<ColaboradorProfile, String>> fetchProfile();
}
