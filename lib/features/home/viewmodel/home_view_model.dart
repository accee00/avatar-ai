import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/features/home/repository/home_repository.dart';
import 'package:avatar_ai/features/home/viewmodel/home_state.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;

  @override
  Future<HomeState> build() async {
    _homeRepository = ref.watch(homeRepositoryProvider);
    final Either<AppFailure, List<Character>> response = await _homeRepository
        .getDefaultCharacters();
    final Either<AppFailure, List<Character>> userCharacters =
        await _homeRepository.getUserCreatedCharacterPaginated(limit: 10);

    return response.fold(
      (AppFailure failure) => HomeState(errorMessage: failure.message),
      (List<Character> characters) => HomeState(
        frequentlyUsed: characters.sublist(5),
        forYou: characters.sublist(6, 10),
        newToYou: userCharacters.getOrElse((l) => []),
      ),
    );
  }
}
