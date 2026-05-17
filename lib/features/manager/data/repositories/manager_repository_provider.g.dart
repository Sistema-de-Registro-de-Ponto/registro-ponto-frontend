// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(managerRepository)
final managerRepositoryProvider = ManagerRepositoryProvider._();

final class ManagerRepositoryProvider
    extends
        $FunctionalProvider<
          ManagerRepository,
          ManagerRepository,
          ManagerRepository
        >
    with $Provider<ManagerRepository> {
  ManagerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'managerRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$managerRepositoryHash();

  @$internal
  @override
  $ProviderElement<ManagerRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ManagerRepository create(Ref ref) {
    return managerRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ManagerRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ManagerRepository>(value),
    );
  }
}

String _$managerRepositoryHash() => r'2ab3288434537960c30682512d2b3182d0d02eac';
