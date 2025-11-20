// lib/data/memory_repository.dart

import '../models/memory.dart';
import '../utils/date_helper.dart';

class MemoryRepository {
  // Hardcoded Mock Data using ISO 8601 Standard (YYYY-MM-DDTHH:MM:SS)
  final List<Memory> _mockMemories = const [
    Memory(
      date: '2025-10-08T03:00:00', // Was: Tuesday, October 8...
      content: 'Today was an incredible day! I went hiking up the mountain...',
      tags: ['hiking', 'nature', 'adventure'],
      emoji: '⛰️',
    ),
    Memory(
      date: '2025-10-07T03:00:00', // Was: Monday, October 7...
      content: 'Started reading a new book today called "The Midnight Library". Already 100 pages in...',
      imagePath: 'lib/mock/image.png',
      tags: ['books', 'coffee', 'relaxation'],
      emoji: '📚',
    ),
    Memory(
      date: '2025-10-06T22:00:00', // Was: Sunday, October 6...
      content: 'Just a simple note for today. Feeling grateful.',
      tags: ['gratitude'],
    ),
    Memory(
      date: '2025-10-05T03:00:00', // Was: October 5...
      content: 'Family dinner tonight was wonderful. Mom made her famous lasagna.',
      tags: ['family', 'food', 'gratitude'],
    ),
  ];

  Future<List<Memory>> getMemories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockMemories;
  }

  // Updated to use the central DateHelper
  DateTime? parseDate(String dateString) {
    return DateHelper.parse(dateString);
  }
}