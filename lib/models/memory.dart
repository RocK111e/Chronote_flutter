// lib/models/memory.dart

class Memory {
  final String date;
  final String content;
  final List<String> tags;
  final String? emoji;
  final String? imagePath;

  const Memory({
    required this.date,
    required this.content,
    this.tags = const [],
    this.emoji,
    this.imagePath,
  });
}