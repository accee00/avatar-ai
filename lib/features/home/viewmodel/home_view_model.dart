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
}
