import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/features/colaborador/presentation/views/colaborador_shell_loaded.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

import '../view_models/colaborador_profile_view_model.dart';

class ColaboradorShellPage extends ConsumerWidget {
  const ColaboradorShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(colaboradorProfileViewModelProvider);

    return asyncProfile.when(
      data: (profile) => ColaboradorShellLoaded(profile: profile),
      loading: () => const Scaffold(body: Center(child: AppLoading())),
      error: (_, _) => Scaffold(
        body: Center(
          child: AppError(
            'Não foi possível carregar seus dados.',
            onRetry: () => ref.invalidate(colaboradorProfileViewModelProvider),
          ),
        ),
      ),
    );
  }
}
