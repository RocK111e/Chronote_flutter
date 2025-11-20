// lib/utils/date_helper.dart

import 'package:intl/intl.dart';

class DateHelper {
  static DateTime? parseDate(String dateString) {
    // Format 1: With Day of Week (e.g., Tuesday, October 8, 2025 at 03:00 AM)
    try {
      return DateFormat("EEEE, MMMM d, yyyy 'at' hh:mm a").parse(dateString);
    } catch (_) {}

    // Format 2: Without Day of Week (e.g., October 5, 2025 at 03:00 AM)
    try {
      return DateFormat("MMMM d, yyyy 'at' hh:mm a").parse(dateString);
    } catch (_) {}

    return null;
  }

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}