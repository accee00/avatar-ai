import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

/// Global Firebase Auth instance provider
/// Use this provider anywhere you need FirebaseAuth
@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(Ref ref) {
  return FirebaseAuth.instance;
}

/// Global Google Sign-In instance provider
/// Use this provider anywhere you need GoogleSignIn
@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(Ref ref) {
  return GoogleSignIn.instance;
}
