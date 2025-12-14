// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_history_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatHistoryViewModel)
const chatHistoryViewModelProvider = ChatHistoryViewModelProvider._();

final class ChatHistoryViewModelProvider
    extends $AsyncNotifierProvider<ChatHistoryViewModel, List<HistoryModel>> {
  const ChatHistoryViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatHistoryViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatHistoryViewModelHash();

  @$internal
  @override
  ChatHistoryViewModel create() => ChatHistoryViewModel();
}

String _$chatHistoryViewModelHash() =>
    r'c04ffeeca02f40725c5e71999b3cf490f8ebf75c';

abstract class _$ChatHistoryViewModel
    extends $AsyncNotifier<List<HistoryModel>> {
  FutureOr<List<HistoryModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<HistoryModel>>, List<HistoryModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<HistoryModel>>, List<HistoryModel>>,
              AsyncValue<List<HistoryModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
