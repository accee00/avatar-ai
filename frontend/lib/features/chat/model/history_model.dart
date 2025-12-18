import 'package:avatar_ai/features/chat/model/message_model.dart';
import 'package:avatar_ai/features/myavatar/model/character_model.dart';

class HistoryModel {
  final Message lastMessage;
  final Character character;

  HistoryModel({required this.character, required this.lastMessage});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      character: Character.fromJson(json['character']),
      lastMessage: Message.fromJson(json['lastMessage']),
    );
  }
}
