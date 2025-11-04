import 'dart:ui';

class Character {
  final String id;
  final String name;
  final String tagline;
  final String avatar;
  final String createdBy;
  final Color avatarColor;
  final int chats;
  final String? description;
  final List<String> tags;
  final DateTime createdAt;
  final bool isFavorite;
  final double? rating;
  final String? tone;
  final List<String> greetings;
  final bool aiGreetingEnabled;

  const Character({
    required this.id,
    required this.createdBy,
    required this.name,
    required this.tagline,
    required this.avatar,
    required this.avatarColor,
    this.chats = 0,
    this.description,
    this.tags = const [],
    required this.createdAt,
    this.isFavorite = false,
    this.rating,
    this.tone,
    this.greetings = const [],
    this.aiGreetingEnabled = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdBy': createdBy,
      'tagline': tagline,
      'avatar': avatar,
      'avatarColor': avatarColor.value,
      'chats': chats,
      'description': description,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
      'isFavorite': isFavorite,
      'rating': rating,
      'tone': tone,
      'greetings': greetings,
      'aiGreetingEnabled': aiGreetingEnabled,
    };
  }

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      id: json['id'] as String,
      createdBy: json['createdBy'] as String,
      name: json['name'] as String,
      tagline: json['tagline'] as String,
      avatar: json['avatar'] as String,
      avatarColor: Color(json['avatarColor'] as int),
      chats: (json['chats'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavorite: json['isFavorite'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble(),
      tone: json['tone'] as String?,
      greetings:
          (json['greetings'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      aiGreetingEnabled: json['aiGreetingEnabled'] as bool? ?? false,
    );
  }

  Character copyWith({
    String? id,
    String? createdBy,
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
    String? tone,
    List<String>? greetings,
    bool? aiGreetingEnabled,
  }) {
    return Character(
      id: id ?? this.id,
      createdBy: createdBy ?? this.createdBy,
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
      tone: tone ?? this.tone,
      greetings: greetings ?? this.greetings,
      aiGreetingEnabled: aiGreetingEnabled ?? this.aiGreetingEnabled,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Character &&
        other.id == id &&
        other.createdBy == createdBy &&
        other.name == name &&
        other.tagline == tagline &&
        other.avatar == avatar &&
        other.avatarColor == avatarColor &&
        other.chats == chats &&
        other.description == description &&
        _listEquals(other.tags, tags) &&
        other.createdAt == createdAt &&
        other.isFavorite == isFavorite &&
        other.rating == rating &&
        other.tone == tone &&
        _listEquals(other.greetings, greetings) &&
        other.aiGreetingEnabled == aiGreetingEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      createdBy,
      name,
      tagline,
      avatar,
      avatarColor,
      chats,
      description,
      _listHash(tags),
      createdAt,
      isFavorite,
      rating,
      tone,
      _listHash(greetings),
      aiGreetingEnabled,
    );
  }

  @override
  String toString() {
    return 'Character(id: $id, name: $name, tagline: $tagline, chats: $chats, isFavorite: $isFavorite)';
  }

  // Helper methods for list equality and hashing
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  int _listHash<T>(List<T> list) {
    return list.fold(0, (hash, element) => hash ^ element.hashCode);
  }
}

extension CharacterExtensions on Character {
  bool get hasDescription => description?.isNotEmpty ?? false;

  bool get isPopular => chats > 1000;

  String get displayTags => tags.join(', ');

  bool get hasCustomGreetings => greetings.isNotEmpty;

  String get displayCreatedAt {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else {
      return 'Just now';
    }
  }
}
