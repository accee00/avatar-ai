import 'dart:io';
import 'dart:typed_data';

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/myavatar/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_repository.g.dart';

@riverpod
AvatarRepository avatarRepository(Ref ref) {
  return AvatarRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseStorageProvider),
    ref.watch(firebaseFireStoreProvider),
  );
}

class AvatarRepository {
  ///
  AvatarRepository(
    this.firebaseAuth,
    this.firebaseStorage,
    this.firebaseFirestore,
  );

  ///
  final FirebaseAuth firebaseAuth;

  ///
  final FirebaseStorage firebaseStorage;

  ///
  final FirebaseFirestore firebaseFirestore;

  ///
  Future<Either<AppFailure, bool>> createCharacter({
    required Character character,
    required File? avatarFile,
  }) async {
    try {
      logInfo('[createCharacter] data: ${character.toString()}');
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

        final Uint8List data = await avatarFile.readAsBytes();

        final TaskSnapshot uploadTask = await storageRef.putData(data);
        downloadUrl = await uploadTask.ref.getDownloadURL();

        logInfo('createCharacter download url $downloadUrl');
      }

      final Map<String, dynamic> data = character
          .copyWith(avatar: downloadUrl, id: docRef.id, createdBy: user.uid)
          .toJson();

      logInfo('[createCharacter] Creating Firestore document...');
      await docRef.set(data);
      logInfo('[createCharacter] Document created successfully');

      return right(true);
    } on FirebaseException catch (e) {
      logError('[createCharacter] FirebaseException: ${e.code} - ${e.message}');
      return left(AppFailure(e.message ?? 'Failed to create character'));
    } catch (e) {
      logError('[createCharacter] Unexpected error: $e');
      return left(AppFailure('Unexpected error: $e'));
    }
  }

  ///
  Future<Either<AppFailure, List<Character>>> getMyCharacters() async {
    try {
      final String userId = firebaseAuth.currentUser!.uid;

      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore
              .collection('characters')
              .where('createdBy', isEqualTo: userId)
              .get();

      final List<Character> characters = querySnapshot.docs.map((doc) {
        final Map<String, dynamic> data = doc.data();
        return Character.fromJson(data);
      }).toList();

      return right(characters);
    } on FirebaseException catch (e) {
      logInfo('[getMyCharacters] exception: $e');
      return left(AppFailure(e.message ?? 'Failed to get character'));
    } catch (e) {
      logInfo('[createCharacter] exception: $e');
      return left(AppFailure('Unexpected error: $e'));
    }
  }

  Future<Either<AppFailure, bool>> deleteCharacter({required String id}) async {
    try {
      final String? userId = firebaseAuth.currentUser?.uid;
      if (userId == null) return left(AppFailure('User not authenticated'));

      // final DocumentSnapshot<Map<String, dynamic>> doc = await firebaseFirestore
      //     .collection('characters')
      //     .doc(id)
      //     .get();

      // if (doc.data()?['createdBy'] != userId) {
      //   return left(
      //     AppFailure('Unauthorized: Cannot delete others\' characters'),
      //   );
      // }

      await firebaseFirestore.collection('characters').doc(id).delete();
      return right(true);
    } on FirebaseException catch (e) {
      logInfo('[deleteCharacter] exception: $e');
      return left(AppFailure(e.message ?? 'Failed to get character'));
    } catch (e) {
      logInfo('[deleteCharacter] exception: $e');
      return left(AppFailure('Unexpected error: $e'));
    }
  }

  Future<Either<AppFailure, bool>> updateCharacter({
    required Character character,
    File? avatarFile,
  }) async {
    try {
      final User? user = firebaseAuth.currentUser;
      if (user == null) {
        return left(AppFailure('User not authenticated'));
      }

      final docRef = firebaseFirestore
          .collection('characters')
          .doc(character.id);
      String? downloadUrl;

      if (avatarFile != null) {
        try {
          // Delete old avatar if it exists
          if (character.avatar.isNotEmpty) {
            try {
              await firebaseStorage
                  .ref()
                  .child('avatars/${user.uid}/${character.id}.jpg')
                  .delete();
              logInfo('Old avatar deleted successfully');
            } on FirebaseException catch (e) {
              if (e.code != 'object-not-found') {
                logWarning('Failed to delete old avatar: $e');
              }
            }
          }

          final Reference storageRef = firebaseStorage.ref().child(
            'avatars/${user.uid}/${character.id}.jpg',
          );

          final Uint8List data = await avatarFile.readAsBytes();

          final TaskSnapshot uploadTask = await storageRef.putData(data);
          downloadUrl = await uploadTask.ref.getDownloadURL();
          logInfo('Avatar upload successful: $downloadUrl');
        } on FirebaseException catch (e) {
          logError(
            '[updateCharacter] Storage operation failed: ${e.code} - ${e.message}',
          );
          return left(AppFailure('Failed to update avatar: ${e.message}'));
        }
      }

      final Map<String, dynamic> updateData = character
          .copyWith(avatar: downloadUrl ?? character.avatar)
          .toJson();

      await docRef.update(updateData);
      logInfo('Character updated successfully');

      return right(true);
    } on FirebaseException catch (e) {
      logError(
        '[updateCharacter] Firebase exception: ${e.code} - ${e.message}',
      );
      return left(AppFailure(e.message ?? 'Failed to update character'));
    } catch (e) {
      logError('[updateCharacter] Unexpected error: $e');
      return left(AppFailure('Unexpected error occurred'));
    }
  }
}
