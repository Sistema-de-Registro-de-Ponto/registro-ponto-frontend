// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator_profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CollaboratorProfileViewModel)
final collaboratorProfileViewModelProvider =
    CollaboratorProfileViewModelProvider._();

final class CollaboratorProfileViewModelProvider
    extends
        $AsyncNotifierProvider<
          CollaboratorProfileViewModel,
          CollaboratorProfile
        > {
  CollaboratorProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collaboratorProfileViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collaboratorProfileViewModelHash();

  @$internal
  @override
  CollaboratorProfileViewModel create() => CollaboratorProfileViewModel();
}

String _$collaboratorProfileViewModelHash() =>
    r'5f22112ec12d4a82b9f02077a8f38e6becca67bc';

abstract class _$CollaboratorProfileViewModel
    extends $AsyncNotifier<CollaboratorProfile> {
  FutureOr<CollaboratorProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<CollaboratorProfile>, CollaboratorProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CollaboratorProfile>, CollaboratorProfile>,
              AsyncValue<CollaboratorProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
