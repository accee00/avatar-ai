import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/chat/model/history_model.dart';
import 'package:avatar_ai/features/chat/model/message_model.dart';
import 'package:avatar_ai/features/myavatar/model/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(ref.watch(firebaseFireStoreProvider));
}

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;

  ChatRepository(this.firebaseFirestore);

  Future<void> incrementCharacterChatCount(String characterId) async {
    try {
      await firebaseFirestore.collection('characters').doc(characterId).update({
        'chats': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found' || e.code == 'permission-denied') {
        await firebaseFirestore
            .collection('public_characters')
            .doc(characterId)
            .update({'chats': FieldValue.increment(1)});
      } else {
        rethrow;
      }
    }
  }

  Future<void> addToFavorites(String userId, String characterId) async {
    await firebaseFirestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayUnion([characterId]),
    });
  }

  Future<void> removeFromFavorites(String userId, String characterId) async {
    await firebaseFirestore.collection('users').doc(userId).update({
      'favorites': FieldValue.arrayRemove([characterId]),
    });
  }

  Future<bool> isFavorite(String userId, String characterId) async {
    final doc = await firebaseFirestore.collection('users').doc(userId).get();
    final favorites = List<String>.from(doc.data()?['favorites'] ?? []);
    return favorites.contains(characterId);
  }

  Future<void> addToBookmarks(
    String userId,
    Map<String, dynamic> bookmarkData,
  ) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookmarkData['id'])
        .set(bookmarkData);
  }

  Future<void> removeFromBookmarks(String userId, String bookmarkId) async {
    await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookmarkId)
        .delete();
  }

  Future<bool> isBookmarked(String userId, String characterId) async {
    final doc = await firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(characterId)
        .get();
    return doc.exists;
  }

  Stream<QuerySnapshot> getBookmarksStream(String userId) {
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> saveMessage({
    required String userId,
    required String characterId,
    required Message message,
  }) async {
    final chatRef = firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(characterId);

    await chatRef.set({
      'characterId': characterId,
      'lastMessageAt': message.timestamp,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await chatRef.collection('messages').doc(message.id).set(message.toJson());
  }

  Stream<List<Message>> getMessagesStream({
    required String userId,
    required String characterId,
  }) {
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .doc(characterId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((d) => Message.fromJson(d.data())).toList(),
        );
  }

  Future<List<HistoryModel>> getHistory(String userId) async {
    try {
      final chatsSnapshot = await firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .orderBy('updatedAt', descending: true)
          .get();

      final List<HistoryModel> history = [];

      for (final chatDoc in chatsSnapshot.docs) {
        final characterId = chatDoc.id;

        final lastMessageSnap = await chatDoc.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (lastMessageSnap.docs.isEmpty) continue;

        final lastMessage = Message.fromJson(lastMessageSnap.docs.first.data());

        DocumentSnapshot<Map<String, dynamic>> characterSnap =
            await firebaseFirestore
                .collection('characters')
                .doc(characterId)
                .get();

        if (!characterSnap.exists) {
          characterSnap = await firebaseFirestore
              .collection('public_characters')
              .doc(characterId)
              .get();
        }

        if (!characterSnap.exists) continue;

        final character = Character.fromJson(characterSnap.data()!);

        history.add(
          HistoryModel(character: character, lastMessage: lastMessage),
        );
      }

      return history;
    } catch (e, s) {
      logInfo('getHistory error: $e');
      logInfo('StackTrace: $s');
      rethrow;
    }
  }
}
