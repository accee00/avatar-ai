import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/features/auth/model/user_model.dart';
import 'package:avatar_ai/features/auth/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRepository _authRepository;

  @override
  AsyncValue<UserModel>? build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return null;
  }

  Future<void> signInViaEmailAndPass({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();

    final Either<AppFailure, UserModel> response = await _authRepository
        .signInViaEmailAndPassword(email: email, password: password);

    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (UserModel user) => state = AsyncData(user),
    );
  }

  Future<void> signUpViaGoogle() async {
    state = AsyncValue.loading();

    final Either<AppFailure, UserModel> response = await _authRepository
        .signInWithGoogle();

    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (UserModel user) => state = AsyncData(user),
    );
  }
}
