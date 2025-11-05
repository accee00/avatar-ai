import 'package:avatar_ai/models/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState {
  final List<Character> forYou;
  final List<Character> newToYou;
  final List<Character> frequentlyUsed;
  final DocumentSnapshot? lastForYouDocument;
  final DocumentSnapshot? lastNewToYouDocument;
  final DocumentSnapshot? lastFrequentlyUsedDocument;
  final bool hasMoreForYou;
  final bool hasMoreNewToYou;
  final bool hasMoreFrequentlyUsed;
  final bool isLoadingMore;
  final String? errorMessage;
  HomeState({
    this.forYou = const [],
    this.newToYou = const [],
    this.frequentlyUsed = const [],
    this.lastForYouDocument,
    this.lastNewToYouDocument,
    this.lastFrequentlyUsedDocument,
    this.hasMoreForYou = true,
    this.hasMoreNewToYou = true,
    this.hasMoreFrequentlyUsed = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<Character>? forYou,
    List<Character>? newToYou,
    List<Character>? frequentlyUsed,
    DocumentSnapshot? lastForYouDocument,
    DocumentSnapshot? lastNewToYouDocument,
    DocumentSnapshot? lastFrequentlyUsedDocument,
    bool? hasMoreForYou,
    bool? hasMoreNewToYou,
    bool? hasMoreFrequentlyUsed,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return HomeState(
      forYou: forYou ?? this.forYou,
      newToYou: newToYou ?? this.newToYou,
      frequentlyUsed: frequentlyUsed ?? this.frequentlyUsed,
      lastForYouDocument: lastForYouDocument ?? this.lastForYouDocument,
      lastNewToYouDocument: lastNewToYouDocument ?? this.lastNewToYouDocument,
      lastFrequentlyUsedDocument:
          lastFrequentlyUsedDocument ?? this.lastFrequentlyUsedDocument,
      hasMoreForYou: hasMoreForYou ?? this.hasMoreForYou,
      hasMoreNewToYou: hasMoreNewToYou ?? this.hasMoreNewToYou,
      hasMoreFrequentlyUsed:
          hasMoreFrequentlyUsed ?? this.hasMoreFrequentlyUsed,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
