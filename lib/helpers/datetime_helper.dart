import 'package:intl/intl.dart';

class DateTimeHelper {
  static String getDate(DateTime date) {
    final Duration duration = DateTime.now().difference(date);
    if (duration.inMinutes == 0)
      return 'just now';
    else if (duration.inHours == 0)
      return '${duration.inMinutes} min ago';
    else if (duration.inDays == 0)
      return '${duration.inHours} h ago';
    else if (duration.inDays == 1)
      return 'Yesterday';
    else
      return DateFormat.d().add_MMM().format(date);
  }
}
