// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'colaborador_profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ColaboradorProfileViewModel)
final colaboradorProfileViewModelProvider =
    ColaboradorProfileViewModelProvider._();

final class ColaboradorProfileViewModelProvider
    extends
        $AsyncNotifierProvider<
          ColaboradorProfileViewModel,
          ColaboradorProfile
        > {
  ColaboradorProfileViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colaboradorProfileViewModelProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colaboradorProfileViewModelHash();

  @$internal
  @override
  ColaboradorProfileViewModel create() => ColaboradorProfileViewModel();
}

String _$colaboradorProfileViewModelHash() =>
    r'5a290043dbf6778d8ddeef5e13f8094bf8c8ebc6';

abstract class _$ColaboradorProfileViewModel
    extends $AsyncNotifier<ColaboradorProfile> {
  FutureOr<ColaboradorProfile> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ColaboradorProfile>, ColaboradorProfile>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ColaboradorProfile>, ColaboradorProfile>,
              AsyncValue<ColaboradorProfile>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
