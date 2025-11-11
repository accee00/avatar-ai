import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/features/auth/model/user_model.dart';
import 'package:avatar_ai/features/auth/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  late AuthRepository _authRepository;

  @override
  AsyncValue<UserModel?> build() {
    _authRepository = ref.watch(authRepositoryProvider);
    return const AsyncValue.data(null);
  }

  Future<void> signUpViaEmailAndPass({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();

    final Either<AppFailure, UserModel> response = await _authRepository
        .signUpViaEmailAndPassword(
          name: name,
          email: email,
          password: password,
        );

    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (UserModel user) => state = AsyncData(user),
    );
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

    if (!ref.mounted) return;

    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (UserModel user) => state = AsyncData(user),
    );
  }

  Future<void> forgotPassword({required String email}) async {
    state = const AsyncValue.loading();

    final Either<AppFailure, bool> response = await _authRepository
        .forgotPassword(email: email);

    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (bool _) => state = AsyncData(null),
    );
  }

  Future<void> getCurrentUser() async {
    state = const AsyncValue.loading();

    final Either<AppFailure, UserModel> response = await _authRepository
        .getCurrentUser();

    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (UserModel user) => state = AsyncData(user),
    );
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();

    final Either<AppFailure, Unit> response = await _authRepository.signOut();
    if (!ref.mounted) return;
    response.fold(
      (AppFailure failure) =>
          state = AsyncError(failure.message, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}
