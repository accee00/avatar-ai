import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/auth/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
  );
}

class AuthRepository {
  ///
  final FirebaseAuth firebaseAuth;

  ///
  final GoogleSignIn googleSignIn;

  ///
  AuthRepository(this.firebaseAuth, this.googleSignIn);

  Future<Either<AppFailure, UserModel>> signUpViaEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final UserCredential response = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final User? user = response.user;

      if (user == null) {
        return left(AppFailure('User is null'));
      }

      await user.updateDisplayName(name.trim());
      await user.reload();
      final updatedUser = firebaseAuth.currentUser;

      return right(UserModel.fromFirebaseUser(updatedUser!));
    } on FirebaseAuthException catch (e) {
      logInfo("[signUpViaEmailAndPassword] exception: ${e.toString()}");
      return left(AppFailure(e.message ?? 'An unexpected error occurred.'));
    } catch (e) {
      logInfo("[signUpViaEmailAndPassword] unknown error: $e");
      return left(AppFailure('Something went wrong.'));
    }
  }

  ///
  Future<Either<AppFailure, UserModel>> signInViaEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential response = await firebaseAuth
          .signInWithEmailAndPassword(
            email: email.trim(),
            password: password.trim(),
          );

      final User? user = response.user;

      if (user == null) {
        return left(AppFailure('User is null'));
      }
      return right(UserModel.fromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      logInfo("[signInViaEmailAndPassword] exception: ${e.toString()}");
      return left(AppFailure(e.message ?? 'An unexpected error occur.'));
    }
  }

  ///
  Future<Either<AppFailure, UserModel>> signInWithGoogle() async {
    try {
      await googleSignIn.initialize();
      await googleSignIn.signOut();
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate(
        scopeHint: ['email'],
      );
      final GoogleSignInClientAuthorization? googleAuth = await googleUser
          .authorizationClient
          .authorizationForScopes(['email']);
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleUser.authentication.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? user = userCredential.user;
      if (user == null) {
        return left(AppFailure('User is null'));
      }
      return right(UserModel.fromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      logInfo("[signInWithGoogle] exception: ${e.toString()}");
      return left(AppFailure(e.message ?? 'An unexpected error occur.'));
    } catch (e) {
      logInfo("[signInWithGoogle] exception: ${e.toString()}");
      return left(AppFailure('An unexpected error occurred: ${e.toString()}'));
    }
  }

  ///
  Future<Either<AppFailure, Unit>> signOut() async {
    try {
      await firebaseAuth.signOut();
      return right(unit);
    } catch (e) {
      logInfo("[signOut] exception: ${e.toString()}");
      return left(AppFailure('Failed to sign out: ${e.toString()}'));
    }
  }

  Future<Either<AppFailure, bool>> forgotPassword({
    required String email,
  }) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
      return right(true);
    } on FirebaseAuthException catch (e) {
      logInfo("[forgotPassword] exception: ${e.toString()}");
      return left(AppFailure(e.message ?? 'An unexpected error occurred.'));
    } catch (e) {
      logInfo("[forgotPassword] unknown error: $e");
      return left(
        AppFailure('Failed to send password reset email: ${e.toString()}'),
      );
    }
  }

  ///
  Future<Either<AppFailure, UserModel>> getCurrentUser() async {
    try {
      final User? user = firebaseAuth.currentUser;

      if (user == null) {
        return left(AppFailure('No authenticated user found'));
      }

      await user.reload();
      final User? reloadedUser = firebaseAuth.currentUser;

      if (reloadedUser == null) {
        return left(AppFailure('Failed to reload user data'));
      }

      return right(UserModel.fromFirebaseUser(reloadedUser));
    } on FirebaseAuthException catch (e) {
      logInfo("[getCurrentUser] exception: ${e.toString()}");
      return left(AppFailure(e.message ?? 'An unexpected error occurred.'));
    } catch (e) {
      logInfo("[getCurrentUser] unknown error: $e");
      return left(AppFailure('Failed to get current user: ${e.toString()}'));
    }
  }
}
