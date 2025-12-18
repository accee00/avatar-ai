import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/myavatar/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_repository.g.dart';

typedef PaginatedCharacters = ({
  List<Character> characters,
  DocumentSnapshot? lastDocument,
});

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFireStoreProvider),
  );
}

class HomeRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  HomeRepository(this.firebaseAuth, this.firebaseFirestore);

  /// Fetches the initial list of public/default characters (non-paginated).
  Future<Either<AppFailure, List<Character>>> getDefaultCharacters() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await firebaseFirestore
              .collection('public_characters')
              .orderBy('createdAt', descending: false)
              .get();

      final List<Character> characters = querySnapshot.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                Character.fromJson(doc.data()),
          )
          .toList();

      return right(characters);
    } on FirebaseException catch (e) {
      logInfo('[getDefaultCharacters] exception home repo: $e');
      return left(
        AppFailure(e.message ?? 'An unknown Firebase error occurred.'),
      );
    }
  }

  Future<Either<AppFailure, PaginatedCharacters>>
  getUserCreatedCharacterPaginated({
    int limit = 30,
    DocumentSnapshot? lastDocument,
  }) async {
    try {
      Query<Map<String, dynamic>> query = firebaseFirestore
          .collection('characters')
          .orderBy('createdAt', descending: true)
          .limit(limit);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await query
          .get();

      final List<Character> userCharacter = querySnapshot.docs
          .map(
            (QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
                Character.fromJson(doc.data()),
          )
          .toList();

      // Determine the last document for the next page fetch
      final DocumentSnapshot? newLastDocument = querySnapshot.docs.isNotEmpty
          ? querySnapshot.docs.last
          : null;

      return right((characters: userCharacter, lastDocument: newLastDocument));
    } on FirebaseException catch (e) {
      logInfo('[getUserCreatedCharacterPaginated] exception home repo: $e');
      return left(
        AppFailure(e.message ?? 'An unknown Firebase error occurred.'),
      );
    }
  }
}
