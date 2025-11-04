import 'dart:io';

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/features/myavatar/repository/avatar_repository.dart';
import 'package:avatar_ai/features/myavatar/viewmodel/avatar_state.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:fpdart/fpdart.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_viewmodel.g.dart';

@riverpod
class AvatarViewmodel extends _$AvatarViewmodel {
  late AvatarRepository _avatarRepository;

  @override
  Future<AvatarState> build() async {
    _avatarRepository = ref.watch(avatarRepositoryProvider);

    final Either<AppFailure, List<Character>> response = await _avatarRepository
        .getMyCharacters();

    return response.fold(
      (AppFailure failure) => AvatarState(errorMessage: failure.message),
      (List<Character> characters) => AvatarState(myCharacters: characters),
    );
  }

  Future<void> createAvatar({
    required Character character,
    required File? avatarFile,
  }) async {
    state = AsyncValue.data(
      state.value!.copyWith(
        isLoading: true,
        errorMessage: null, // Clear error here
        isCharacterCreated: false, // Also reset other flags
      ),
    );

    final Either<AppFailure, bool> response = await _avatarRepository
        .createCharacter(character: character, avatarFile: avatarFile);

    response.fold(
      (AppFailure failure) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: failure.message,
            isCharacterCreated: false,
          ),
        );
      },
      (bool success) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            isCharacterCreated: success,
            errorMessage: null,
          ),
        );

        if (success) {
          ref.invalidateSelf();
        }
      },
    );
  }

  Future<void> deleteCharacter({required String characterId}) async {
    state = AsyncValue.data(
      state.value!.copyWith(
        isLoading: true,
        errorMessage: null, // Clear error here
        isCharacterCreated: false, // Also reset other flags
      ),
    );
    final Either<AppFailure, bool> response = await _avatarRepository
        .deleteCharacter(id: characterId);

    response.fold(
      (AppFailure failure) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (bool success) {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, errorMessage: null),
        );

        if (success) {
          ref.invalidateSelf();
        }
      },
    );
  }

  Future<void> updateCharacter({
    required Character character,
    File? avatarFile,
  }) async {
    state = AsyncValue.data(
      state.value!.copyWith(
        isLoading: true,
        errorMessage: null, // Clear error here
        isCharacterCreated: false, // Also reset other flags
      ),
    );

    final Either<AppFailure, bool> response = await _avatarRepository
        .updateCharacter(character: character, avatarFile: avatarFile);

    response.fold(
      (AppFailure failure) {
        state = AsyncValue.data(
          state.value!.copyWith(
            isLoading: false,
            errorMessage: failure.message,
          ),
        );
      },
      (bool success) {
        state = AsyncValue.data(
          state.value!.copyWith(isLoading: false, errorMessage: null),
        );

        if (success) {
          ref.invalidateSelf();
        }
      },
    );
  }

  Future<void> refreshCharacters() async {
    ref.invalidateSelf();
  }
}
