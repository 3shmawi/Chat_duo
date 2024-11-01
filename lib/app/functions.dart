import 'package:intl/intl.dart';

String daysBetween(String date) {
  final parsedDate = DateTime.parse(date);
  if (DateTime.now().difference(parsedDate).inDays <= 5) {
    if ((DateTime.now().difference(parsedDate).inHours / 24).round() == 0) {
      if (DateTime.now().difference(parsedDate).inHours == 0) {
        if (DateTime.now().difference(parsedDate).inMinutes == 0) {
          return 'now';
        } else {
          return '${DateTime.now().difference(parsedDate).inMinutes.toString()}m';
        }
      } else {
        return '${DateTime.now().difference(parsedDate).inHours.toString()}h';
      }
    } else {
      return (' ${(DateTime.now().difference(parsedDate).inHours / 24).round().toString()}d');
    }
  } else {
    return formatDate(parsedDate.toString());
  }
}

String formatDate(String date) {
  return DateFormat('dd MMMM yyyy').format(
    DateTime.parse(date),
  );
}
