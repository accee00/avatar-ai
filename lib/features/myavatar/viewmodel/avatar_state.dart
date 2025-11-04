import 'package:avatar_ai/models/character_model.dart';
import 'package:flutter/foundation.dart';

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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AvatarState &&
        listEquals(other.myCharacters, myCharacters) &&
        other.isLoading == isLoading &&
        other.errorMessage == errorMessage &&
        other.isCharacterCreated == isCharacterCreated;
  }

  @override
  int get hashCode {
    return Object.hash(
      myCharacters,
      isLoading,
      errorMessage,
      isCharacterCreated,
    );
  }
}
