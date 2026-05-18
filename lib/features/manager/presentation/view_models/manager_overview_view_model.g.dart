// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_overview_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagerOverviewViewModel)
final managerOverviewViewModelProvider = ManagerOverviewViewModelProvider._();

final class ManagerOverviewViewModelProvider
    extends $NotifierProvider<ManagerOverviewViewModel, ManagerOverviewState> {
  ManagerOverviewViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerOverviewViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerOverviewViewModelHash();

  @$internal
  @override
  ManagerOverviewViewModel create() => ManagerOverviewViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagerOverviewState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagerOverviewState>(value),
    );
  }
}

String _$managerOverviewViewModelHash() =>
    r'94b1192f7aeb03a4a9f2fd096df387ad3c773b8f';

abstract class _$ManagerOverviewViewModel
    extends $Notifier<ManagerOverviewState> {
  ManagerOverviewState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ManagerOverviewState, ManagerOverviewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ManagerOverviewState, ManagerOverviewState>,
              ManagerOverviewState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
