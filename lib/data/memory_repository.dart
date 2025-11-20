import 'package:intl/intl.dart';
import '../models/memory.dart';

class MemoryRepository {
  // Hardcoded Mock Data
  final List<Memory> _mockMemories = const [
    Memory(
      date: 'Tuesday, October 8, 2025 at 03:00 AM',
      content: 'Test wor. Today was an incredible day! I went hiking up the mountain...',
      tags: ['hiking', 'nature', 'adventure'],
      emoji: '⛰️',
    ),
    Memory(
      date: 'Monday, October 7, 2025 at 03:00 AM',
      content: 'Started reading a new book today called "The Midnight Library". Already 100 pages in...',
      imagePath: 'lib/mock/image.png',
      tags: ['books', 'coffee', 'relaxation'],
      emoji: '📚',
    ),
    Memory(
      date: 'Sunday, October 6, 2025 at 10:00 PM',
      content: 'Just a simple note for today. Feeling grateful.',
      tags: ['gratitude'],
    ),
    Memory(
      date: 'October 5, 2025 at 03:00 AM',
      content: 'Family dinner tonight was wonderful. Mom made her famous lasagna.',
      tags: ['family', 'food', 'gratitude'],
    ),
  ];

  Future<List<Memory>> getMemories() async {
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
    return _mockMemories;
  }

  /// Parses the string date from Memory model into a DateTime object.
  /// Handles formats:
  /// 1. "Tuesday, October 8, 2025 at 03:00 AM"
  /// 2. "October 5, 2025 at 03:00 AM"
  DateTime? parseDate(String dateString) {
    // Format 1: With Day of Week (e.g., Tuesday, ...)
    try {
      return DateFormat("EEEE, MMMM d, yyyy 'at' hh:mm a").parse(dateString);
    } catch (_) {
      // Continue to next format if this fails
    }

    // Format 2: Without Day of Week
    try {
      return DateFormat("MMMM d, yyyy 'at' hh:mm a").parse(dateString);
    } catch (e) {
      // print("Error parsing date: $dateString - $e");
      return null;
    }
  }
}