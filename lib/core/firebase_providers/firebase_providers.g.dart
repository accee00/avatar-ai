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
