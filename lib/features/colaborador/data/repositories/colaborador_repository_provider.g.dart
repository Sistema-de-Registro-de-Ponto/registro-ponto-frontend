// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colaborador_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(colaboradorRepository)
final colaboradorRepositoryProvider = ColaboradorRepositoryProvider._();

final class ColaboradorRepositoryProvider
    extends
        $FunctionalProvider<
          ColaboradorRepository,
          ColaboradorRepository,
          ColaboradorRepository
        >
    with $Provider<ColaboradorRepository> {
  ColaboradorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colaboradorRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colaboradorRepositoryHash();

  @$internal
  @override
  $ProviderElement<ColaboradorRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ColaboradorRepository create(Ref ref) {
    return colaboradorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColaboradorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColaboradorRepository>(value),
    );
  }
}

String _$colaboradorRepositoryHash() =>
    r'01f149b4a958de0044498b4ae397c45c09d202d9';
