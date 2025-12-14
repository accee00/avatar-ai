import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/features/chat/model/history_model.dart';
import 'package:avatar_ai/features/chat/repository/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'chat_history_view_model.g.dart';

@riverpod
class ChatHistoryViewModel extends _$ChatHistoryViewModel {
  late final ChatRepository _chatRepository;
  late final FirebaseAuth _firebaseAuth;
  @override
  Future<List<HistoryModel>> build() async {
    _chatRepository = ref.watch(chatRepositoryProvider);
    _firebaseAuth = ref.watch(firebaseAuthProvider);

    final userId = _firebaseAuth.currentUser!.uid;

    return _chatRepository.getHistory(userId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userId = _firebaseAuth.currentUser!.uid;
      return _chatRepository.getHistory(userId);
    });
  }
}
