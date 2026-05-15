import '../models/collaborator_profile_dto.dart';

abstract class CollaboratorRemoteDataSource {
  Future<CollaboratorProfileDto> fetchProfile();
}
