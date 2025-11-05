// lib/features/home/viewmodel/home_state.dart

import 'package:avatar_ai/models/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeState {
  final List<Character> forYou;
  final List<Character> newToYou;
  final List<Character> featured;
  final DocumentSnapshot? lastForYouDocument;
  final DocumentSnapshot? lastNewToYouDocument;
  final DocumentSnapshot? lastFeaturedDocument;
  final bool hasMoreForYou;
  final bool hasMoreNewToYou;
  final bool hasMoreFeatured;
  final bool isLoadingMore;
  final String? errorMessage;

  HomeState({
    this.forYou = const [],
    this.newToYou = const [],
    this.featured = const [],
    this.lastForYouDocument,
    this.lastNewToYouDocument,
    this.lastFeaturedDocument,
    this.hasMoreForYou = true,
    this.hasMoreNewToYou = true,
    this.hasMoreFeatured = true,
    this.isLoadingMore = false,
    this.errorMessage,
  });

  HomeState copyWith({
    List<Character>? forYou,
    List<Character>? newToYou,
    List<Character>? featured,
    DocumentSnapshot? lastForYouDocument,
    DocumentSnapshot? lastNewToYouDocument,
    DocumentSnapshot? lastFeaturedDocument,
    bool? hasMoreForYou,
    bool? hasMoreNewToYou,
    bool? hasMoreFeatured,
    bool? isLoadingMore,
    String? errorMessage,
  }) {
    return HomeState(
      forYou: forYou ?? this.forYou,
      newToYou: newToYou ?? this.newToYou,
      featured: featured ?? this.featured,
      lastForYouDocument: lastForYouDocument ?? this.lastForYouDocument,
      lastNewToYouDocument: lastNewToYouDocument ?? this.lastNewToYouDocument,
      lastFeaturedDocument: lastFeaturedDocument ?? this.lastFeaturedDocument,
      hasMoreForYou: hasMoreForYou ?? this.hasMoreForYou,
      hasMoreNewToYou: hasMoreNewToYou ?? this.hasMoreNewToYou,
      hasMoreFeatured: hasMoreFeatured ?? this.hasMoreFeatured,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
