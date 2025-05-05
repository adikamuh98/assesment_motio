import 'package:intl/intl.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
  static final DateFormat _displayFormat = DateFormat('dd MMM yyyy HH:mm');

  static String format(String date) {
    final DateTime parsedDate = _dateFormat.parse(date);
    return _displayFormat.format(parsedDate);
  }

  static String parse(DateTime date) {
    return _dateFormat.format(date);
  }
}
