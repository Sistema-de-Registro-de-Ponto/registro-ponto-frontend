// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthSessionController)
final authSessionControllerProvider = AuthSessionControllerProvider._();

final class AuthSessionControllerProvider
    extends $AsyncNotifierProvider<AuthSessionController, AuthSession?> {
  AuthSessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionControllerHash();

  @$internal
  @override
  AuthSessionController create() => AuthSessionController();
}

String _$authSessionControllerHash() =>
    r'36e04c707ef5a3a1ff34017ef8e832e29b9ba6a0';

abstract class _$AuthSessionController extends $AsyncNotifier<AuthSession?> {
  FutureOr<AuthSession?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthSession?>, AuthSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSession?>, AuthSession?>,
              AsyncValue<AuthSession?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
