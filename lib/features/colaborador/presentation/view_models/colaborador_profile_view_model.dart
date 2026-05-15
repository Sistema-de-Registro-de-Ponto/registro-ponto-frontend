import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/result.dart';
import '../../data/repositories/colaborador_repository_provider.dart';
import '../../domain/entities/colaborador_profile.dart';

part 'colaborador_profile_view_model.g.dart';

@Riverpod(keepAlive: true)
class ColaboradorProfileViewModel extends _$ColaboradorProfileViewModel {
  @override
  Future<ColaboradorProfile> build() async {
    final result = await ref.read(colaboradorRepositoryProvider).fetchProfile();

    switch (result) {
      case Success<ColaboradorProfile, String>():
        return result.value;
      case Failure<ColaboradorProfile, String>():
        return ColaboradorProfile(userId: 0, firstName: 'Desconhecido');
    }
  }
}
