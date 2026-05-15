import '../models/colaborador_profile_dto.dart';

abstract class ColaboradorRemoteDataSource {
  Future<ColaboradorProfileDto> fetchProfile();
}
