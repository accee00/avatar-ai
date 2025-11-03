import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final DateTime createdAt;
  final DateTime? lastActive;
  final bool isPremium;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.createdAt,
    this.lastActive,
    this.isPremium = false,
    this.preferences,
  });
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      id: user.uid,
      name: user.displayName ?? '',
      createdAt: DateTime.now(),
      email: user.email ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
      'isPremium': isPremium,
      'preferences': preferences,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] != null
          ? DateTime.parse(json['lastActive'] as String)
          : null,
      isPremium: json['isPremium'] as bool? ?? false,
      preferences: json['preferences'] as Map<String, dynamic>?,
    );
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatar,
    DateTime? createdAt,
    DateTime? lastActive,
    bool? isPremium,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      lastActive: lastActive ?? this.lastActive,
      isPremium: isPremium ?? this.isPremium,
      preferences: preferences ?? this.preferences,
    );
  }
}
