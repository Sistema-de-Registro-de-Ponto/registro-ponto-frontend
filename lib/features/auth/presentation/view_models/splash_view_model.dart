import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'auth_session_controller.dart';
import 'splash_destination.dart';
import 'splash_min_display_duration.dart';

part 'splash_view_model.g.dart';

@riverpod
class SplashViewModel extends _$SplashViewModel {
  @override
  Future<SplashDestination> build() async {
    final minDuration = ref.read(splashMinDisplayDurationProvider);
    final sessionFuture = ref.read(authSessionControllerProvider.future);

    await Future.wait([
      Future<void>.delayed(minDuration),
      sessionFuture,
    ]);

    final asyncSession = ref.read(authSessionControllerProvider);

    return switch (asyncSession) {
      AsyncData(:final value) => value != null ? SplashDestination.home : SplashDestination.login,
      _ => SplashDestination.login,
    };
  }
}
