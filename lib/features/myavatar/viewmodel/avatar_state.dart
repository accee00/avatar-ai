import 'package:avatar_ai/models/character_model.dart';

class AvatarState {
  final List<Character> myCharacters;
  final bool isLoading;
  final String? errorMessage;
  final bool isCharacterCreated;

  const AvatarState({
    this.myCharacters = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isCharacterCreated = false,
  });

  AvatarState copyWith({
    List<Character>? myCharacters,
    bool? isLoading,
    String? errorMessage,
    bool? isCharacterCreated,
  }) {
    return AvatarState(
      myCharacters: myCharacters ?? this.myCharacters,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isCharacterCreated: isCharacterCreated ?? this.isCharacterCreated,
    );
  }
}
