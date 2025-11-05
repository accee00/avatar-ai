// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AvatarViewmodel)
const avatarViewmodelProvider = AvatarViewmodelProvider._();

final class AvatarViewmodelProvider
    extends $AsyncNotifierProvider<AvatarViewmodel, AvatarState> {
  const AvatarViewmodelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarViewmodelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarViewmodelHash();

  @$internal
  @override
  AvatarViewmodel create() => AvatarViewmodel();
}

String _$avatarViewmodelHash() => r'03a24e81e3cce713a477675010466d5ae2d949c3';

abstract class _$AvatarViewmodel extends $AsyncNotifier<AvatarState> {
  FutureOr<AvatarState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AvatarState>, AvatarState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AvatarState>, AvatarState>,
              AsyncValue<AvatarState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
