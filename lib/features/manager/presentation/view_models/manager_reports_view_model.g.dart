// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_reports_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagerReportsViewModel)
final managerReportsViewModelProvider = ManagerReportsViewModelProvider._();

final class ManagerReportsViewModelProvider
    extends $NotifierProvider<ManagerReportsViewModel, ManagerReportsState> {
  ManagerReportsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerReportsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerReportsViewModelHash();

  @$internal
  @override
  ManagerReportsViewModel create() => ManagerReportsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagerReportsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagerReportsState>(value),
    );
  }
}

String _$managerReportsViewModelHash() =>
    r'd93081b2585230d68c878b7887e444ab7e0e50fc';

abstract class _$ManagerReportsViewModel
    extends $Notifier<ManagerReportsState> {
  ManagerReportsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ManagerReportsState, ManagerReportsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ManagerReportsState, ManagerReportsState>,
              ManagerReportsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
