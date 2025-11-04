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
    extends $NotifierProvider<AvatarViewmodel, AsyncValue<AvatarState>> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<AvatarState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<AvatarState>>(value),
    );
  }
}

String _$avatarViewmodelHash() => r'b59e4d9c9946f8ac13f305e8a789eb82a7adad1b';

abstract class _$AvatarViewmodel extends $Notifier<AsyncValue<AvatarState>> {
  AsyncValue<AvatarState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AvatarState>, AsyncValue<AvatarState>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AvatarState>, AsyncValue<AvatarState>>,
              AsyncValue<AvatarState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
