import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/collaborator_repository_provider.dart';
import '../../domain/entities/collaborator_profile.dart';

part 'collaborator_profile_view_model.g.dart';

@Riverpod(keepAlive: true)
class CollaboratorProfileViewModel extends _$CollaboratorProfileViewModel {
  @override
  Future<CollaboratorProfile> build() async {
    final result = await ref.read(collaboratorRepositoryProvider).fetchProfile();

    switch (result) {
      case Success<CollaboratorProfile, String>():
        return result.value;
      case Failure<CollaboratorProfile, String>():
        return CollaboratorProfile(userId: 0, firstName: 'Desconhecido');
    }
  }
}
