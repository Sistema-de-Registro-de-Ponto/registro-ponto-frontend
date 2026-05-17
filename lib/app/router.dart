import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_navigation.dart';
import '../features/auth/presentation/view_models/auth_session_controller.dart';
import '../features/auth/presentation/views/login_page.dart';
import '../features/auth/presentation/views/splash_page.dart';
import '../features/collaborator/presentation/views/collaborator_shell_page.dart';
import '../features/manager/presentation/views/manager_shell_page.dart';
import 'routes.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refresh = _RouterRefresh();
  ref.listen(authSessionControllerProvider, (_, _) => refresh.notify());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: refresh,
    redirect: (context, state) {
      final onSplash = state.matchedLocation == Routes.splash;
      if (onSplash) return null;

      final asyncSession = ref.read(authSessionControllerProvider);
      if (asyncSession.isLoading) return Routes.splash;

      final loggedIn = asyncSession.value != null;
      final goingToLogin = state.matchedLocation == Routes.login;

      if (!loggedIn && !goingToLogin) return Routes.login;
      if (loggedIn && goingToLogin) return asyncSession.value!.role.shellRoute;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        name: 'splash',
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: Routes.home,
        name: 'home',
        builder: (_, _) => const CollaboratorShellPage(),
      ),
      GoRoute(
        path: Routes.management,
        name: 'management',
        builder: (_, _) => const ManagerShellPage(),
      ),
      GoRoute(
        path: Routes.login,
        name: 'login',
        builder: (_, _) => const LoginPage(),
      ),
    ],
  );
}

class _RouterRefresh extends ChangeNotifier {
  void notify() => notifyListeners();
}
