import 'package:intl/intl.dart';

timeStartToEnd(String start, String end) {
  String startTime = DateFormat("HH:mm").format(DateTime.parse(start));
  String endTime = DateFormat("HH:mm").format(DateTime.parse(end));

  return "$startTime - $endTime WIB";
}
