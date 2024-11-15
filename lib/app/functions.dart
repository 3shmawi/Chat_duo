import 'package:intl/intl.dart';

import '../model/user.dart';

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

String newId(String myId, String otherId) {
  String id = myId + otherId;
  List<String> idChars = id.split(''); // Split into individual characters
  idChars.sort(); // Sort alphabetically
  return idChars.join(); // Join sorted characters back into a string
}

String getFirstNames(List<UserModel> users, String myId) {
  if (users.isEmpty) return "";

  // Remove myself from the list
  users.removeWhere((user) => user.id == myId);

  // Extract first names
  List<String> firstNames =
      users.map((user) => user.name.split(" ").first).toList();

  // Add "you" to the list if it's not empty
  firstNames.insert(0, "You");

  // Join with a comma
  return firstNames.join(", ");
}
