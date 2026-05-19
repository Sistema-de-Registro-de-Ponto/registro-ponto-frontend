// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_rpa_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagerRpaViewModel)
final managerRpaViewModelProvider = ManagerRpaViewModelProvider._();

final class ManagerRpaViewModelProvider
    extends $NotifierProvider<ManagerRpaViewModel, ManagerRpaState> {
  ManagerRpaViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerRpaViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerRpaViewModelHash();

  @$internal
  @override
  ManagerRpaViewModel create() => ManagerRpaViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagerRpaState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagerRpaState>(value),
    );
  }
}

String _$managerRpaViewModelHash() =>
    r'83290dd37452af7444606be0a56f55ebf83d449a';

abstract class _$ManagerRpaViewModel extends $Notifier<ManagerRpaState> {
  ManagerRpaState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ManagerRpaState, ManagerRpaState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ManagerRpaState, ManagerRpaState>,
              ManagerRpaState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
