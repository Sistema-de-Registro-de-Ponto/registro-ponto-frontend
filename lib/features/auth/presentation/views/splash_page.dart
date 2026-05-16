import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_ponto_frontend/app/routes.dart';
import 'package:registro_ponto_frontend/shared/app_brand_logo.dart';
import 'package:registro_ponto_frontend/shared/app_loading.dart';

import '../view_models/splash_destination.dart';
import '../view_models/splash_view_model.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(splashViewModelProvider, (_, next) {
      next.whenData((destination) {
        if (!context.mounted) return;

        final location = switch (destination) {
          SplashDestination.home => Routes.home,
          SplashDestination.login => Routes.login,
        };
        context.go(location);
      });
    });

    ref.watch(splashViewModelProvider);

    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [AppBrandLogo(), SizedBox(height: 32), AppLoading()],
        ),
      ),
    );
  }
}
