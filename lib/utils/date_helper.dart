// lib/utils/date_helper.dart

import 'package:intl/intl.dart';

class DateHelper {
  // UPDATED: Short Day (EEE), Short Month (MMM), 24-Hour Time (HH:mm)
  static final DateFormat _displayFormatter = DateFormat("EEE, MMM d, yyyy HH:mm");

  static DateTime? parse(String dateString) {
    try {
      return DateTime.parse(dateString);
    } catch (_) {
      return null;
    }
  }

  static String formatDisplayDate(String isoDateString) {
    final date = parse(isoDateString);
    if (date == null) return isoDateString;
    return _displayFormatter.format(date);
  }

  static bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}