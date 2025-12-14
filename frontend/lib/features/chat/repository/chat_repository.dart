import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/chat/model/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(Ref ref) {
  return ChatRepository(ref.watch(firebaseFireStoreProvider));
}

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  /// Increment character chat count
  Future<void> incrementChatCount(String characterId) async {
    try {
      logInfo('Incrementing chat count in characters');
      await _firestore.collection('characters').doc(characterId).update({
        'chats': FieldValue.increment(1),
      });
    } on FirebaseException catch (e) {
      if (e.code == 'not-found' || e.code == 'permission-denied') {
        try {
          logInfo('Fallback: Incrementing chat count in public_characters');
          await _firestore
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

  /// Save message to Firestore
  Future<void> saveMessage(Message message) async {
    try {
      logInfo('Saving chat messages');
      await _firestore
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());
    } catch (e) {
      throw Exception('Failed to save message: $e');
    }
  }

  /// Get messages for a character
  Stream<List<Message>> getMessages(String characterId) {
    logInfo("Get messages for a character");
    return _firestore
        .collection('messages')
        .where('characterId', isEqualTo: characterId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList(),
        );
  }
}
