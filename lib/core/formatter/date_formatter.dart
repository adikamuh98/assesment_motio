import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy');

  static String formatDisplayDate(String date) {
    final DateTime parsedDate = _dateFormat.tryParse(date) ?? DateTime.now();
    return _displayFormat.format(parsedDate);
  }

  static String parseDisplayDate(DateTime date) {
    return _displayFormat.format(date);
  }

  static String format(String date) {
    final DateTime parsedDate = _dateFormat.tryParse(date) ?? DateTime.now();
    return _dateFormat.format(parsedDate);
  }

  static String formatDateTime(DateTime date) {
    return _dateFormat.format(date);
  }

  static DateTime parse(String date) {
    return _dateFormat.parse(date);
  }
}
