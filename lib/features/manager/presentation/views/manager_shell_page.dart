import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/view_models/manager_profile_view_model.dart';
import 'package:registro_ponto_frontend/features/manager/presentation/views/manager_shell_loaded.dart';
import 'package:registro_ponto_frontend/shared/app_error.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

class ManagerShellPage extends ConsumerWidget {
  const ManagerShellPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(managerProfileViewModelProvider);

    return asyncProfile.when(
      data: (profile) => ManagerShellLoaded(profile: profile),
      loading: () => const Scaffold(body: Center(child: AppLoading())),
      error: (_, _) => Scaffold(
        body: Center(
          child: AppError(
            'Não foi possível carregar seus dados.',
            onRetry: () => ref.invalidate(managerProfileViewModelProvider),
          ),
        ),
      ),
    );
  }
}
