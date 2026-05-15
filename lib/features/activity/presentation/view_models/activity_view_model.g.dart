// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivityViewModel)
final activityViewModelProvider = ActivityViewModelProvider._();

final class ActivityViewModelProvider
    extends $NotifierProvider<ActivityViewModel, ActivityState> {
  ActivityViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityViewModelHash();

  @$internal
  @override
  ActivityViewModel create() => ActivityViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ActivityState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ActivityState>(value),
    );
  }
}

String _$activityViewModelHash() => r'2a66bcf4b480f21cd98f18622a8a5041382a900e';

abstract class _$ActivityViewModel extends $Notifier<ActivityState> {
  ActivityState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ActivityState, ActivityState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ActivityState, ActivityState>,
              ActivityState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
