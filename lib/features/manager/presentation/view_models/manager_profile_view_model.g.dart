// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagerProfileViewModel)
final managerProfileViewModelProvider = ManagerProfileViewModelProvider._();

final class ManagerProfileViewModelProvider
    extends $AsyncNotifierProvider<ManagerProfileViewModel, ManagerProfile> {
  ManagerProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerProfileViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerProfileViewModelHash();

  @$internal
  @override
  ManagerProfileViewModel create() => ManagerProfileViewModel();
}

String _$managerProfileViewModelHash() =>
    r'239aa3f5c29d52c7d6ba62936f8914d83b739c81';

abstract class _$ManagerProfileViewModel
    extends $AsyncNotifier<ManagerProfile> {
  FutureOr<ManagerProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ManagerProfile>, ManagerProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ManagerProfile>, ManagerProfile>,
              AsyncValue<ManagerProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
