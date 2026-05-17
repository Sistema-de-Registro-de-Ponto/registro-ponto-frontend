import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/manager_repository_provider.dart';
import '../../domain/entities/manager_profile.dart';

part 'manager_profile_view_model.g.dart';

@Riverpod(keepAlive: true)
class ManagerProfileViewModel extends _$ManagerProfileViewModel {
  @override
  Future<ManagerProfile> build() async {
    final result = await ref.read(managerRepositoryProvider).fetchProfile();

    switch (result) {
      case Success<ManagerProfile, String>():
        return result.value;
      case Failure<ManagerProfile, String>():
        return const ManagerProfile(userId: 0, firstName: 'Desconhecido');
    }
  }
}
