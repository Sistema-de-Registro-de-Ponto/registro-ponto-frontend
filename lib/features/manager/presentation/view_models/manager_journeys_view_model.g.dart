// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_journeys_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagerJourneysViewModel)
final managerJourneysViewModelProvider = ManagerJourneysViewModelProvider._();

final class ManagerJourneysViewModelProvider
    extends $NotifierProvider<ManagerJourneysViewModel, ManagerJourneysState> {
  ManagerJourneysViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerJourneysViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerJourneysViewModelHash();

  @$internal
  @override
  ManagerJourneysViewModel create() => ManagerJourneysViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagerJourneysState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagerJourneysState>(value),
    );
  }
}

String _$managerJourneysViewModelHash() =>
    r'b36cc6d15ab16f8956b624f69ec90c8c854fa178';

abstract class _$ManagerJourneysViewModel
    extends $Notifier<ManagerJourneysState> {
  ManagerJourneysState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ManagerJourneysState, ManagerJourneysState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ManagerJourneysState, ManagerJourneysState>,
              ManagerJourneysState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
