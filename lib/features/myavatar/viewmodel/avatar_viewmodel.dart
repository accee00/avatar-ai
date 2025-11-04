import 'dart:io';

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/features/myavatar/repository/avatar_repository.dart';
import 'package:avatar_ai/features/myavatar/viewmodel/avatar_state.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:fpdart/src/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'avatar_viewmodel.g.dart';

@riverpod
class AvatarViewmodel extends _$AvatarViewmodel {
  late AvatarRepository _avatarRepository;

  @override
  AsyncValue<AvatarState> build() {
    _avatarRepository = ref.watch(avatarRepositoryProvider);
    return AsyncValue.data(const AvatarState());
  }

  Future<void> createAvatar({
    required Character character,
    required File? avatarFile,
  }) async {
    state = AsyncValue.data(
      state.value!.copyWith(
        isLoading: true,
        errorMessage: null,
        isCharacterCreated: false,
      ),
    );

    final Either<AppFailure, bool> response = await _avatarRepository
        .createCharacter(character: character, avatarFile: avatarFile);

    response.fold(
      (failure) => state = AsyncValue.data(
        state.value!.copyWith(
          isLoading: false,
          errorMessage: failure.message,
          isCharacterCreated: false,
        ),
      ),
      (success) => state = AsyncValue.data(
        state.value!.copyWith(
          isLoading: false,
          errorMessage: null,
          isCharacterCreated: success,
        ),
      ),
    );
  }
}
