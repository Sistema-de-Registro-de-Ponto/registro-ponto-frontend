// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_history_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(JourneyHistoryViewModel)
final journeyHistoryViewModelProvider = JourneyHistoryViewModelProvider._();

final class JourneyHistoryViewModelProvider
    extends $NotifierProvider<JourneyHistoryViewModel, JourneyHistoryState> {
  JourneyHistoryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyHistoryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyHistoryViewModelHash();

  @$internal
  @override
  JourneyHistoryViewModel create() => JourneyHistoryViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JourneyHistoryState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JourneyHistoryState>(value),
    );
  }
}

String _$journeyHistoryViewModelHash() =>
    r'503beaf4ee231ab5cf196f1048f8295e45e230cf';

abstract class _$JourneyHistoryViewModel
    extends $Notifier<JourneyHistoryState> {
  JourneyHistoryState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<JourneyHistoryState, JourneyHistoryState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JourneyHistoryState, JourneyHistoryState>,
              JourneyHistoryState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
