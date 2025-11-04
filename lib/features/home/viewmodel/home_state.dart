import 'package:avatar_ai/models/character_model.dart';

class HomeState {
  final List<Character> frequentlyUsed;
  final List<Character> forYou;
  final List<Character> newToYou;

  final bool isLoading;
  final String? errorMessage;
  final bool isCharacterCreated;

  const HomeState({
    this.frequentlyUsed = const [],
    this.forYou = const [],
    this.newToYou = const [],
    this.isLoading = false,
    this.errorMessage,
    this.isCharacterCreated = false,
  });

  HomeState copyWith({
    List<Character>? frequentlyUsed,
    List<Character>? forYou,
    List<Character>? newToYou,
    bool? isLoading,
    String? errorMessage,
    bool? isCharacterCreated,
  }) {
    return HomeState(
      frequentlyUsed: frequentlyUsed ?? this.frequentlyUsed,
      forYou: forYou ?? this.forYou,
      newToYou: newToYou ?? this.newToYou,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isCharacterCreated: isCharacterCreated ?? this.isCharacterCreated,
    );
  }
}
