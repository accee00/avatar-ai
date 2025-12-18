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

  /// Increment character chat count
  Future<void> incrementCharacterChatCount(String characterId) async {
    try {
      logInfo('Incrementing chat count in characters');
      await firebaseFirestore.collection('characters').doc(characterId).update({
        'chats': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found' || e.code == 'permission-denied') {
        try {
          logInfo('Fallback: Incrementing chat count in public_characters');
          await firebaseFirestore
              .collection('public_characters')
              .doc(characterId)
              .update({'chats': FieldValue.increment(1)});
        } catch (fallbackError) {
          throw Exception(
            'Failed to increment chat count in public_characters: $fallbackError',
          );
        }
      } else {
        throw Exception('Firestore error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  /// Add character to favorites
  Future<void> addToFavorites(String userId, String characterId) async {
    try {
      await firebaseFirestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayUnion([characterId]),
      });
    } catch (e) {
      throw Exception('Failed to add to favorites: $e');
    }
  }

  /// Remove character from favorites
  Future<void> removeFromFavorites(String userId, String characterId) async {
    try {
      await firebaseFirestore.collection('users').doc(userId).update({
        'favorites': FieldValue.arrayRemove([characterId]),
      });
    } catch (e) {
      throw Exception('Failed to remove from favorites: $e');
    }
  }

  /// Check if character is in favorites
  Future<bool> isFavorite(String userId, String characterId) async {
    try {
      final doc = await firebaseFirestore.collection('users').doc(userId).get();
      final favorites = List<String>.from(doc.data()?['favorites'] ?? []);
      return favorites.contains(characterId);
    } catch (e) {
      return false;
    }
  }

  /// Add chat to bookmarks
  Future<void> addToBookmarks(
    String userId,
    Map<String, dynamic> bookmarkData,
  ) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(bookmarkData['id'])
          .set(bookmarkData);
    } catch (e) {
      throw Exception('Failed to add to bookmarks: $e');
    }
  }

  /// Remove chat from bookmarks
  Future<void> removeFromBookmarks(String userId, String bookmarkId) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(bookmarkId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove from bookmarks: $e');
    }
  }

  /// Check if chat is bookmarked
  Future<bool> isBookmarked(String userId, String characterId) async {
    try {
      final doc = await firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('bookmarks')
          .doc(characterId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Get user's bookmarks
  Stream<QuerySnapshot> getBookmarksStream(String userId) {
    return firebaseFirestore
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  /// Save message to Firestore
  Future<void> saveMessage({
    required String userId,
    required String characterId,
    required Message message,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(characterId)
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  /// Get messages for a character
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
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
        );
  }

  Future<List<HistoryModel>> getHistory(String userId) async {
    try {
      final chatsSnapshot = await firebaseFirestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .get();

      final List<HistoryModel> history = [];

      for (final chatDoc in chatsSnapshot.docs) {
        final chatId = chatDoc.id;

        // Get last message
        final lastMessageSnap = await chatDoc.reference
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .limit(1)
            .get();

        if (lastMessageSnap.docs.isEmpty) {
          continue;
        }

        final lastMessageData = lastMessageSnap.docs.first.data();

        final lastMessage = Message.fromJson(lastMessageData);

        // Get character info
        final characterSnap = await firebaseFirestore
            .collection('characters')
            .doc(chatId)
            .get();

        if (!characterSnap.exists) {
          continue;
        }

        final character = Character.fromJson(characterSnap.data()!);

        history.add(
          HistoryModel(character: character, lastMessage: lastMessage),
        );
      }

      return history;
    } catch (e) {
      throw Exception('Failed to get history: $e');
    }
  }
}
