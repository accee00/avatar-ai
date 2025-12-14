class Message {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String? characterId;
  final String? userId;
  final MessageStatus status;
  final List<String>? attachments;
  final bool isEdited;
  final DateTime? editedAt;

  Message({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.characterId,
    this.userId,
    this.status = MessageStatus.sent,
    this.attachments,
    this.isEdited = false,
    this.editedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'characterId': characterId,
      'userId': userId,
      'status': status.toString().split('.').last,
      'attachments': attachments,
      'isEdited': isEdited,
      'editedAt': editedAt?.toIso8601String(),
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      characterId: json['characterId'] as String?,
      userId: json['userId'] as String?,
      status: MessageStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      isEdited: json['isEdited'] as bool? ?? false,
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
    );
  }

  Message copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? characterId,
    String? userId,
    MessageStatus? status,
    List<String>? attachments,
    bool? isEdited,
    DateTime? editedAt,
  }) {
    return Message(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      characterId: characterId ?? this.characterId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      attachments: attachments ?? this.attachments,
      isEdited: isEdited ?? this.isEdited,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}

enum MessageStatus { sending, sent, delivered, read, failed }
