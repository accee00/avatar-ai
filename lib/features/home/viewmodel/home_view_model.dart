// lib/features/home/viewmodel/home_view_model.dart

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/features/home/repository/home_repository.dart';
import 'package:avatar_ai/features/home/viewmodel/home_state.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;
  final int _limit = 5;

  @override
  Future<HomeState> build() async {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return _loadInitialData();
  }

  Future<HomeState> _loadInitialData() async {
    final Either<AppFailure, List<Character>> defaultResponse =
        await _homeRepository.getDefaultCharacters();

    final Either<AppFailure, PaginatedCharacters> userResponse =
        await _homeRepository.getUserCreatedCharacterPaginated(limit: _limit);

    return defaultResponse.fold(
      (AppFailure failure) => HomeState(errorMessage: failure.message),
      (List<Character> defaultCharacters) {
        final PaginatedCharacters userPaginatedData = userResponse.getOrElse(
          (l) => (characters: [], lastDocument: null),
        );

        final List<Character> userCharacters = userPaginatedData.characters;
        final DocumentSnapshot? lastUserDoc = userPaginatedData.lastDocument;

        final bool hasMore = userCharacters.length == _limit;

        return HomeState(
          featured: defaultCharacters.sublist(0, 5),
          forYou: defaultCharacters.sublist(5),
          newToYou: userCharacters,
          lastNewToYouDocument: lastUserDoc,
          hasMoreNewToYou: hasMore,
        );
      },
    );
  }

  Future<void> loadMoreNewToYou() async {
    // 1. Guard Clauses & State Access
    if (!state.hasValue) return;

    final HomeState currentState = state.value!;

    // Do not load if already loading, or if no more data is available
    if (currentState.isLoadingMore || !currentState.hasMoreNewToYou) {
      return;
    }

    // 2. Set Loading State
    state = AsyncData(currentState.copyWith(isLoadingMore: true));

    // Use the updated state for the repository call
    final HomeState newState = state.value!;

    // 3. Call Repository, passing the last known document
    final Either<AppFailure, PaginatedCharacters> result = await _homeRepository
        .getUserCreatedCharacterPaginated(
          limit: _limit,
          lastDocument: newState.lastNewToYouDocument,
        );

    result.fold(
      (AppFailure failure) {
        state = AsyncData(
          newState.copyWith(
            isLoadingMore: false,
            errorMessage: failure.message,
          ),
        );
      },
      // On Success
      (PaginatedCharacters paginatedData) {
        final List<Character> newCharacters = paginatedData.characters;
        final bool hasMore = newCharacters.length == _limit;

        logInfo(
          '[loadMoreNewToYou] Fetched ${newCharacters.length} characters, hasMore: $hasMore',
        );
        state = AsyncData(
          newState.copyWith(
            newToYou: <Character>[...newState.newToYou, ...newCharacters],
            lastNewToYouDocument: paginatedData.lastDocument,
            hasMoreNewToYou: hasMore,
            isLoadingMore: false,
            errorMessage: null,
          ),
        );
      },
    );
  }
}
