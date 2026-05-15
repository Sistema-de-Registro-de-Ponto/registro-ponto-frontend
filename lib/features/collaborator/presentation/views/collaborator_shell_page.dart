import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/features/collaborator/presentation/views/collaborator_shell_loaded.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

import '../view_models/collaborator_profile_view_model.dart';

class CollaboratorShellPage extends ConsumerWidget {
  const CollaboratorShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(collaboratorProfileViewModelProvider);

    return asyncProfile.when(
      data: (profile) => CollaboratorShellLoaded(profile: profile),
      loading: () => const Scaffold(body: Center(child: AppLoading())),
      error: (_, _) => Scaffold(
        body: Center(
          child: AppError(
            'Não foi possível carregar seus dados.',
            onRetry: () => ref.invalidate(collaboratorProfileViewModelProvider),
          ),
        ),
      ),
    );
  }
}
