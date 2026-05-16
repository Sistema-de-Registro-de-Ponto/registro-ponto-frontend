// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JourneyViewModel)
final journeyViewModelProvider = JourneyViewModelProvider._();

final class JourneyViewModelProvider
    extends $NotifierProvider<JourneyViewModel, JourneyState> {
  JourneyViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyViewModelHash();

  @$internal
  @override
  JourneyViewModel create() => JourneyViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JourneyState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JourneyState>(value),
    );
  }
}

String _$journeyViewModelHash() => r'24f3217a67e2688ac44f19ec3e4362855c370491';

abstract class _$JourneyViewModel extends $Notifier<JourneyState> {
  JourneyState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<JourneyState, JourneyState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JourneyState, JourneyState>,
              JourneyState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
