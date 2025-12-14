import 'dart:convert';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/chat/repository/chat_repository.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:avatar_ai/features/chat/model/message_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_view_model.g.dart';

@riverpod
class ChatViewModel extends _$ChatViewModel {
  late ChatRepository _chatRepository;

  @override
  ChatState build() {
    _chatRepository = ref.watch(chatRepositoryProvider);
    return ChatState(messages: [], isTyping: false, hasIncrementedCount: false);
  }

  void initializeChat(Character character) {
    final greeting = "Hello! I'm ${character.name}. ${character.tagline}";

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: greeting,
      isUser: false,
      timestamp: DateTime.now(),
      characterId: character.id,
    );

    state = state.copyWith(messages: [...state.messages, message]);
  }

  /// Send user message and get AI response
  Future<void> sendMessage(String text, Character character) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
      userId: 'current_user',
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isTyping: true,
    );

    if (!state.hasIncrementedCount) {
      try {
        await _chatRepository.incrementChatCount(character.id);
        state = state.copyWith(hasIncrementedCount: true);
      } catch (e) {
        logInfo('Error incrementing chat count: $e');
      }
    }

    // Get AI response
    await _getAIResponse(text, character);
  }

  /// Get AI response from API
  Future<void> _getAIResponse(String userMessage, Character character) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'messages': state.messages
              .map(
                (m) => {
                  'role': m.isUser ? 'user' : 'assistant',
                  'content': m.text,
                },
              )
              .toList(),
          'character': {
            'name': character.name,
            'tagline': character.tagline,
            'description': character.description,
            'tone': character.tone,
          },
        }),
      );

      if (response.statusCode == 200) {
        final lines = response.body.split('\n');
        String aiResponse = '';

        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = jsonDecode(line.substring(6));
            if (data['text'] != null) {
              aiResponse += data['text'];
            }
            if (data['done'] == true) {
              break;
            }
          }
        }

        final aiMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: aiResponse.trim(),
          isUser: false,
          timestamp: DateTime.now(),
          characterId: character.id,
        );

        state = state.copyWith(
          messages: [...state.messages, aiMessage],
          isTyping: false,
        );
      }
    } catch (e) {
      final errorMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: "Sorry, I couldn't connect. Please try again.",
        isUser: false,
        timestamp: DateTime.now(),
        characterId: character.id,
        status: MessageStatus.failed,
      );

      state = state.copyWith(
        messages: [...state.messages, errorMessage],
        isTyping: false,
      );
    }
  }

  /// Clear all messages (useful for reset)
  void clearMessages() {
    state = ChatState(
      messages: [],
      isTyping: false,
      hasIncrementedCount: false,
    );
  }
}

class ChatState {
  final List<Message> messages;
  final bool isTyping;
  final bool hasIncrementedCount;

  ChatState({
    required this.messages,
    required this.isTyping,
    required this.hasIncrementedCount,
  });

  ChatState copyWith({
    List<Message>? messages,
    bool? isTyping,
    bool? hasIncrementedCount,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      hasIncrementedCount: hasIncrementedCount ?? this.hasIncrementedCount,
    );
  }
}
