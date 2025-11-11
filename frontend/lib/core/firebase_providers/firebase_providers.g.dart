// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Global Firebase Auth instance provider
/// Use this provider anywhere you need FirebaseAuth

@ProviderFor(firebaseAuth)
const firebaseAuthProvider = FirebaseAuthProvider._();

/// Global Firebase Auth instance provider
/// Use this provider anywhere you need FirebaseAuth

final class FirebaseAuthProvider
    extends $FunctionalProvider<FirebaseAuth, FirebaseAuth, FirebaseAuth>
    with $Provider<FirebaseAuth> {
  /// Global Firebase Auth instance provider
  /// Use this provider anywhere you need FirebaseAuth
  const FirebaseAuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseAuthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseAuthHash();

  @$internal
  @override
  $ProviderElement<FirebaseAuth> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseAuth create(Ref ref) {
    return firebaseAuth(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseAuth value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseAuth>(value),
    );
  }
}

String _$firebaseAuthHash() => r'cb440927c3ab863427fd4b052a8ccba4c024c863';

/// Global Google Sign-In instance provider
/// Use this provider anywhere you need GoogleSignIn

@ProviderFor(googleSignIn)
const googleSignInProvider = GoogleSignInProvider._();

/// Global Google Sign-In instance provider
/// Use this provider anywhere you need GoogleSignIn

final class GoogleSignInProvider
    extends $FunctionalProvider<GoogleSignIn, GoogleSignIn, GoogleSignIn>
    with $Provider<GoogleSignIn> {
  /// Global Google Sign-In instance provider
  /// Use this provider anywhere you need GoogleSignIn
  const GoogleSignInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'googleSignInProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$googleSignInHash();

  @$internal
  @override
  $ProviderElement<GoogleSignIn> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoogleSignIn create(Ref ref) {
    return googleSignIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoogleSignIn value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoogleSignIn>(value),
    );
  }
}

String _$googleSignInHash() => r'6b68e7785a816a60cd0c722d8a0ef9c87c7cdc7d';

@ProviderFor(firebaseFireStore)
const firebaseFireStoreProvider = FirebaseFireStoreProvider._();

final class FirebaseFireStoreProvider
    extends
        $FunctionalProvider<
          FirebaseFirestore,
          FirebaseFirestore,
          FirebaseFirestore
        >
    with $Provider<FirebaseFirestore> {
  const FirebaseFireStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseFireStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseFireStoreHash();

  @$internal
  @override
  $ProviderElement<FirebaseFirestore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FirebaseFirestore create(Ref ref) {
    return firebaseFireStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseFirestore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseFirestore>(value),
    );
  }
}

String _$firebaseFireStoreHash() => r'ce7c9988d69067b76afca148c6e26920bd3b99b8';

@ProviderFor(firebaseStorage)
const firebaseStorageProvider = FirebaseStorageProvider._();

final class FirebaseStorageProvider
    extends
        $FunctionalProvider<FirebaseStorage, FirebaseStorage, FirebaseStorage>
    with $Provider<FirebaseStorage> {
  const FirebaseStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firebaseStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firebaseStorageHash();

  @$internal
  @override
  $ProviderElement<FirebaseStorage> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FirebaseStorage create(Ref ref) {
    return firebaseStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FirebaseStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FirebaseStorage>(value),
    );
  }
}

String _$firebaseStorageHash() => r'8e9f5814f2e4871c92e546bca90dbeaf2f43edeb';
