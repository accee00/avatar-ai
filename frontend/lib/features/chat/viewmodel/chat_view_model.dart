import 'dart:async';
import 'dart:convert';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/chat/model/message_model.dart';
import 'package:avatar_ai/features/chat/repository/chat_repository.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  late final ChatRepository _chatRepository;
  StreamSubscription<List<Message>>? _messagesSub;

  @override
  ChatState build() {
    _chatRepository = ref.watch(chatRepositoryProvider);

    ref.onDispose(() {
      _messagesSub?.cancel();
    });

    return ChatState(
      messages: [],
      isTyping: false,
      hasIncrementedCount: false,
      isFavorite: false,
      isBookmarked: false,
    );
  }

  /// INIT CHAT
  Future<void> initializeChat({
    required Character character,
    required String userId,
  }) async {
    _messagesSub?.cancel();

    _messagesSub = _chatRepository
        .getMessagesStream(userId: userId, characterId: character.id)
        .listen((messages) {
          state = state.copyWith(messages: messages);
        });

    final isFav = await _chatRepository.isFavorite(userId, character.id);
    final isBook = await _chatRepository.isBookmarked(userId, character.id);

    state = state.copyWith(isFavorite: isFav, isBookmarked: isBook);

    if (state.messages.isEmpty) {
      final greeting = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Hello! I'm ${character.name}. ${character.tagline}",
        isUser: false,
        timestamp: DateTime.now(),
        characterId: character.id,
        status: MessageStatus.sent,
      );

      await _chatRepository.saveMessage(
        userId: userId,
        characterId: character.id,
        message: greeting,
      );
    }
  }

  /// SEND MESSAGE
  Future<void> sendMessage({
    required String text,
    required Character character,
    required String userId,
  }) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
      userId: userId,
      characterId: character.id,
      status: MessageStatus.sent,
    );

    state = state.copyWith(isTyping: true);

    await _chatRepository.saveMessage(
      userId: userId,
      characterId: character.id,
      message: userMessage,
    );

    if (!state.hasIncrementedCount) {
      await _chatRepository.incrementCharacterChatCount(character.id);
      state = state.copyWith(hasIncrementedCount: true);
    }

    await _getAIResponse(character: character, userId: userId);
  }

  /// AI RESPONSE
  Future<void> _getAIResponse({
    required Character character,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': state.messages.map((m) {
            return {'role': m.isUser ? 'user' : 'assistant', 'content': m.text};
          }).toList(),
          'character': {
            'name': character.name,
            'tagline': character.tagline,
            'description': character.description,
            'tone': character.tone,
          },
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('AI failed');
      }

      final lines = response.body.split('\n');
      String aiText = '';

      for (final line in lines) {
        if (line.startsWith('data: ')) {
          final data = jsonDecode(line.substring(6));
          if (data['text'] != null) aiText += data['text'];
          if (data['done'] == true) break;
        }
      }

      final aiMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: aiText.trim(),
        isUser: false,
        timestamp: DateTime.now(),
        characterId: character.id,
        status: MessageStatus.sent,
      );

      await _chatRepository.saveMessage(
        userId: userId,
        characterId: character.id,
        message: aiMessage,
      );
    } catch (e) {
      logInfo('AI error: $e');
    } finally {
      state = state.copyWith(isTyping: false);
    }
  }

  // Future<void> initializeChat(Character character, String userId) async {
  //   final greeting = "Hello! I'm ${character.name}. ${character.tagline}";

  //   final message = Message(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     text: greeting,
  //     isUser: false,
  //     timestamp: DateTime.now(),
  //     characterId: character.id,
  //   );

  //   final isFav = await _chatRepository.isFavorite(userId, character.id);
  //   final isBook = await _chatRepository.isBookmarked(userId, character.id);

  //   state = state.copyWith(
  //     messages: [...state.messages, message],
  //     isFavorite: isFav,
  //     isBookmarked: isBook,
  //   );
  // }

  /// Toggle favorite status
  Future<void> toggleFavorite(String userId, String characterId) async {
    try {
      if (state.isFavorite) {
        await _chatRepository.removeFromFavorites(userId, characterId);
        state = state.copyWith(isFavorite: false);
      } else {
        await _chatRepository.addToFavorites(userId, characterId);
        state = state.copyWith(isFavorite: true);
      }
    } catch (e) {
      logInfo('Error toggling favorite: $e');
    }
  }

  Future<void> toggleBookmark(String userId, Character character) async {
    try {
      if (state.isBookmarked) {
        await _chatRepository.removeFromBookmarks(userId, character.id);
        state = state.copyWith(isBookmarked: false);
      } else {
        final bookmarkData = {
          'id': character.id,
          'characterId': character.id,
          'characterName': character.name,
          'characterAvatar': character.avatar,
          'characterTagline': character.tagline,
          'timestamp': DateTime.now().toIso8601String(),
        };
        await _chatRepository.addToBookmarks(userId, bookmarkData);
        state = state.copyWith(isBookmarked: true);
      }
    } catch (e) {
      logInfo('Error toggling bookmark: $e');
    }
  }

  // Future<void> sendMessage(String text, Character character) async {
  //   if (text.trim().isEmpty) return;

  //   final userMessage = Message(
  //     id: DateTime.now().millisecondsSinceEpoch.toString(),
  //     text: text,
  //     isUser: true,
  //     timestamp: DateTime.now(),
  //     userId: 'current_user',
  //   );

  //   state = state.copyWith(
  //     messages: [...state.messages, userMessage],
  //     isTyping: true,
  //   );

  //   if (!state.hasIncrementedCount) {
  //     try {
  //       await _chatRepository.incrementCharacterChatCount(character.id);
  //       state = state.copyWith(hasIncrementedCount: true);
  //     } catch (e) {
  //       logInfo('Error incrementing chat count: $e');
  //     }
  //   }

  //   await _getAIResponse(text, character);
  // }

  // /// Get AI response from API
  // Future<void> _getAIResponse(String userMessage, Character character) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://localhost:3000/api/chat'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'messages': state.messages
  //             .map(
  //               (m) => {
  //                 'role': m.isUser ? 'user' : 'assistant',
  //                 'content': m.text,
  //               },
  //             )
  //             .toList(),
  //         'character': {
  //           'name': character.name,
  //           'tagline': character.tagline,
  //           'description': character.description,
  //           'tone': character.tone,
  //         },
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final lines = response.body.split('\n');
  //       String aiResponse = '';

  //       for (final line in lines) {
  //         if (line.startsWith('data: ')) {
  //           final data = jsonDecode(line.substring(6));
  //           if (data['text'] != null) {
  //             aiResponse += data['text'];
  //           }
  //           if (data['done'] == true) {
  //             break;
  //           }
  //         }
  //       }

  //       final aiMessage = Message(
  //         id: DateTime.now().millisecondsSinceEpoch.toString(),
  //         text: aiResponse.trim(),
  //         isUser: false,
  //         timestamp: DateTime.now(),
  //         characterId: character.id,
  //       );

  //       state = state.copyWith(
  //         messages: [...state.messages, aiMessage],
  //         isTyping: false,
  //       );
  //     }
  //   } catch (e) {
  //     final errorMessage = Message(
  //       id: DateTime.now().millisecondsSinceEpoch.toString(),
  //       text: "Sorry, I couldn't connect. Please try again.",
  //       isUser: false,
  //       timestamp: DateTime.now(),
  //       characterId: character.id,
  //       status: MessageStatus.failed,
  //     );

  //     state = state.copyWith(
  //       messages: [...state.messages, errorMessage],
  //       isTyping: false,
  //     );
  //   }
  // }

  void clearMessages() {
    state = ChatState(
      messages: [],
      isTyping: false,
      hasIncrementedCount: false,
      isFavorite: false,
      isBookmarked: false,
    );
  }
}

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final bool hasIncrementedCount;
  final bool isFavorite;
  final bool isBookmarked;

  ChatState({
    required this.messages,
    required this.isTyping,
    required this.hasIncrementedCount,
    required this.isFavorite,
    required this.isBookmarked,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isTyping,
    bool? hasIncrementedCount,
    bool? isFavorite,
    bool? isBookmarked,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      hasIncrementedCount: hasIncrementedCount ?? this.hasIncrementedCount,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }
}
