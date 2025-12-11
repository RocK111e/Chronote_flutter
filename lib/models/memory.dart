// lib/models/memory.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Memory {
  final String? id;
  final String userId;
  final String date;
  final String content;
  final List<String> tags;
  final String? emoji;
  final String? imageUrl; 

  const Memory({
    this.id,
    required this.userId,
    required this.date,
    required this.content,
    this.tags = const [],
    this.emoji,
    this.imageUrl,
  });

  factory Memory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      return Memory(
        id: doc.id,
        userId: '',
        date: DateTime.now().toIso8601String(),
        content: '',
      );
    }

    List<String> safeTags = [];
    if (data['tags'] is List) {
      safeTags = (data['tags'] as List).map((item) => item.toString()).toList();
    }

    return Memory(
      id: doc.id,
      userId: data['userId']?.toString() ?? '',
      date: data['date']?.toString() ?? DateTime.now().toIso8601String(),
      content: data['content']?.toString() ?? '',
      tags: safeTags,
      emoji: data['emoji']?.toString(),
      imageUrl: data['imageUrl']?.toString(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'date': date,
      'content': content,
      'tags': tags,
      'emoji': emoji,
      'imageUrl': imageUrl,
    };
  }

  Memory copyWith({
    String? id,
    String? userId,
    String? date,
    String? content,
    List<String>? tags,
    String? emoji,
    String? imageUrl,
  }) {
    return Memory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      content: content ?? this.content,
      tags: tags ?? this.tags,
      emoji: emoji ?? this.emoji,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
