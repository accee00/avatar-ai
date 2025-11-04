import 'dart:io';

import 'package:avatar_ai/core/failures/failure.dart';
import 'package:avatar_ai/core/firebase_providers/firebase_providers.dart';
import 'package:avatar_ai/core/logger/logger.dart';
import 'package:avatar_ai/models/character_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) {
  return HomeRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(firebaseFireStoreProvider),
  );
}

class HomeRepository {
  ///
  final FirebaseAuth firebaseAuth;

  ///
  final FirebaseFirestore firebaseFirestore;

  ///
  HomeRepository(this.firebaseAuth, this.firebaseFirestore);
}
