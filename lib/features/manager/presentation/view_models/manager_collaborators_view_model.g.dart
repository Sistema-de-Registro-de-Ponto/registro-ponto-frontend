// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_collaborators_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ManagerCollaboratorsViewModel)
final managerCollaboratorsViewModelProvider =
    ManagerCollaboratorsViewModelProvider._();

final class ManagerCollaboratorsViewModelProvider
    extends
        $NotifierProvider<
          ManagerCollaboratorsViewModel,
          ManagerCollaboratorsState
        > {
  ManagerCollaboratorsViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerCollaboratorsViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerCollaboratorsViewModelHash();

  @$internal
  @override
  ManagerCollaboratorsViewModel create() => ManagerCollaboratorsViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagerCollaboratorsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagerCollaboratorsState>(value),
    );
  }
}

String _$managerCollaboratorsViewModelHash() =>
    r'4e9062d049193a9161dd880dfd8049bbd1edd50f';

abstract class _$ManagerCollaboratorsViewModel
    extends $Notifier<ManagerCollaboratorsState> {
  ManagerCollaboratorsState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<ManagerCollaboratorsState, ManagerCollaboratorsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ManagerCollaboratorsState, ManagerCollaboratorsState>,
              ManagerCollaboratorsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
