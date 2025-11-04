import 'dart:io';

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
  AsyncValue<HomeState> build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return const AsyncValue.data(HomeState());
  }

  Future<void> createCharacter({
    required Character character,
    required File? avatarFile,
  }) async {
    // Emit loading state
    state = AsyncValue.data(
      state.value!.copyWith(
        isLoading: true,
        errorMessage: null,
        isCharacterCreated: false,
      ),
    );

    final Either<AppFailure, bool> result = await _homeRepository
        .createCharacter(character: character, avatarFile: avatarFile);

    result.match(
      (failure) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: failure.message,
            isCharacterCreated: false,
          ),
        );
      },
      (_) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: null,
            isCharacterCreated: true,
          ),
        );
      },
    );
  }
}
