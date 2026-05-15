// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collaborator_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(collaboratorRepository)
final collaboratorRepositoryProvider = CollaboratorRepositoryProvider._();

final class CollaboratorRepositoryProvider
    extends
        $FunctionalProvider<
          CollaboratorRepository,
          CollaboratorRepository,
          CollaboratorRepository
        >
    with $Provider<CollaboratorRepository> {
  CollaboratorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'collaboratorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$collaboratorRepositoryHash();

  @$internal
  @override
  $ProviderElement<CollaboratorRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  CollaboratorRepository create(Ref ref) {
    return collaboratorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CollaboratorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CollaboratorRepository>(value),
    );
  }
}

String _$collaboratorRepositoryHash() =>
    r'0e5a483ee4d8ae89628541b1041ae727e4e1199b';
