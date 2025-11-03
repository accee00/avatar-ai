import 'dart:io';

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
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
    required String characterName,
    File? avatarUrl,
    Map<String, dynamic>? extraData,
  }) async {
    try {
      final DocumentReference<Map<String, dynamic>> doc = firebaseFirestore
          .collection('characters')
          .doc();

      final Map<String, dynamic> data = {
        'id': doc.id,
        'userId': firebaseAuth.currentUser!.uid,
        'name': characterName,
        'avatarUrl': avatarUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        if (extraData != null) ...extraData,
      };

      await doc.set(data);

      return right(true);
    } on FirebaseException catch (e) {
      return left(AppFailure(e.message ?? 'Failed to create character'));
    } catch (e) {
      return left(AppFailure('Unexpected error: $e'));
    }
  }
}
