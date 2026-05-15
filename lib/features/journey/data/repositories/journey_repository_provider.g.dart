// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journey_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(journeyRepository)
final journeyRepositoryProvider = JourneyRepositoryProvider._();

final class JourneyRepositoryProvider
    extends
        $FunctionalProvider<
          JourneyRepository,
          JourneyRepository,
          JourneyRepository
        >
    with $Provider<JourneyRepository> {
  JourneyRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'journeyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$journeyRepositoryHash();

  @$internal
  @override
  $ProviderElement<JourneyRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  JourneyRepository create(Ref ref) {
    return journeyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JourneyRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JourneyRepository>(value),
    );
  }
}

String _$journeyRepositoryHash() => r'80b6a7c3dd1520294b4eab6471fb3da71893304c';
