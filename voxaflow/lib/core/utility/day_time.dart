import 'package:intl/intl.dart';

String formatTimestamp(int seconds) {
  final DateTime now = DateTime.now();
  final DateTime date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  
  // Calculate the difference in days by comparing dates at midnight
  final DateTime today = DateTime(now.year, now.month, now.day);
  final DateTime targetDate = DateTime(date.year, date.month, date.day);
  final int diffInDays = today.difference(targetDate).inDays;

  if (diffInDays == 0) {
    return "Today";
  } else if (diffInDays == 1) {
    return "Yesterday";
  } else if (diffInDays < 7) {
    // Returns the name of the day (e.g., Sunday)
    return DateFormat('EEEE').format(date);
  } else if (diffInDays < 14) {
    return "Last week";
  } else if (diffInDays < 30) {
    return "Last month";
  } else {
    // Returns specific date: 11-Jun-2025
    return DateFormat('dd-MMM-yyyy').format(date);
  }
}