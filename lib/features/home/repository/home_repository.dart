import 'dart:io';

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFireStoreProvider),
    ref.watch(firebaseStorageProvider),
  );
}

class HomeRepository {
  ///
  final FirebaseAuth firebaseAuth;

  ///
  final FirebaseFirestore firebaseFirestore;

  ///
  final FirebaseStorage firebaseStorage;

  ///
  HomeRepository(
    this.firebaseAuth,
    this.firebaseFirestore,
    this.firebaseStorage,
  );

  Future<Either<AppFailure, bool>> createCharacter({
    required Character character,
    required File? avatarFile,
  }) async {
    try {
      final User? user = firebaseAuth.currentUser;
      if (user == null) {
        return left(AppFailure('User not logged in'));
      }

      final DocumentReference<Map<String, dynamic>> docRef = firebaseFirestore
          .collection('characters')
          .doc();

      String? downloadUrl;
      if (avatarFile != null) {
        final Reference storageRef = firebaseStorage.ref().child(
          'avatars/${user.uid}/${docRef.id}.jpg',
        );

        final TaskSnapshot uploadTask = await storageRef.putFile(avatarFile);
        downloadUrl = await uploadTask.ref.getDownloadURL();

        logInfo('createCharacter download url $downloadUrl');
      }

      final data = character
          .copyWith(avatar: downloadUrl, id: docRef.id)
          .toJson();

      await docRef.set(data);

      return right(true);
    } on FirebaseException catch (e) {
      return left(AppFailure(e.message ?? 'Failed to create character'));
    } catch (e) {
      return left(AppFailure('Unexpected error: $e'));
    }
  }
}
