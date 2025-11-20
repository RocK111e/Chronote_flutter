// lib/utils/date_helper.dart

import 'package:intl/intl.dart';

class DateHelper {
  /// Standard format for display: "Tuesday, October 8, 2025 at 03:00 AM"
  static final DateFormat _displayFormatter = DateFormat("EEEE, MMMM d, yyyy 'at' hh:mm a");

  /// Parses an ISO 8601 string (Storage format) into a DateTime
  static DateTime? parse(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  /// Takes the stored string (ISO) and returns the formatted display string
  static String formatDisplayDate(String isoDateString) {
    final date = parse(isoDateString);
    if (date == null) return isoDateString; // Fallback if parsing fails
    return _displayFormatter.format(date);
  }

  /// Helper to check if two dates are the same day
  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}