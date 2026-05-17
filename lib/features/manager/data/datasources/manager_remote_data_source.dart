import '../models/manager_profile_dto.dart';

abstract class ManagerRemoteDataSource {
  Future<ManagerProfileDto> fetchProfile();
}
