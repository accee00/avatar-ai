import 'dart:ui';

class Character {
  final String id;
  final String name;
  final String tagline;
  final String avatar;
  final Color avatarColor;
  final int chats;
  final String? description;
  final List<String> tags;
  final DateTime createdAt;
  final bool isFavorite;
  final double? rating;

  Character({
    required this.id,
    required this.name,
    required this.tagline,
    required this.avatar,
    required this.avatarColor,
    required this.chats,
    this.description,
    this.tags = const [],
    required this.createdAt,
    this.isFavorite = false,
    this.rating,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'avatar': avatar,
      'avatarColor': avatarColor.value,
      'chats': chats,
      'description': description,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'rating': rating,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      avatar: json['avatar'] as String,
      avatarColor: Color(json['avatarColor'] as int),
      chats: json['chats'] as int? ?? 0,
      description: json['description'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      rating: json['rating'] as double?,
    );
  }

  Character copyWith({
    String? id,
    String? name,
    String? tagline,
    String? avatar,
    Color? avatarColor,
    int? chats,
    String? description,
    List<String>? tags,
    DateTime? createdAt,
    bool? isFavorite,
    double? rating,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      tagline: tagline ?? this.tagline,
      avatar: avatar ?? this.avatar,
      avatarColor: avatarColor ?? this.avatarColor,
      chats: chats ?? this.chats,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      isFavorite: isFavorite ?? this.isFavorite,
      rating: rating ?? this.rating,
    );
  }
}
