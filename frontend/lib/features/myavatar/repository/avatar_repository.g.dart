// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'avatar_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(avatarRepository)
const avatarRepositoryProvider = AvatarRepositoryProvider._();

final class AvatarRepositoryProvider
    extends
        $FunctionalProvider<
          AvatarRepository,
          AvatarRepository,
          AvatarRepository
        >
    with $Provider<AvatarRepository> {
  const AvatarRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'avatarRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$avatarRepositoryHash();

  @$internal
  @override
  $ProviderElement<AvatarRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AvatarRepository create(Ref ref) {
    return avatarRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AvatarRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AvatarRepository>(value),
    );
  }
}

String _$avatarRepositoryHash() => r'aa8367190b254b8f5248058e79bec51aa7606218';
