// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_min_display_duration.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(splashMinDisplayDuration)
final splashMinDisplayDurationProvider = SplashMinDisplayDurationProvider._();

final class SplashMinDisplayDurationProvider
    extends $FunctionalProvider<Duration, Duration, Duration>
    with $Provider<Duration> {
  SplashMinDisplayDurationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashMinDisplayDurationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashMinDisplayDurationHash();

  @$internal
  @override
  $ProviderElement<Duration> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Duration create(Ref ref) {
    return splashMinDisplayDuration(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Duration value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Duration>(value),
    );
  }
}

String _$splashMinDisplayDurationHash() =>
    r'd29f1c83a75caa2e9e339dc19ee315d49ea4689b';
