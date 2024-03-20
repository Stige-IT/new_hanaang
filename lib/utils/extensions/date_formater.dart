import 'package:intl/intl.dart';

extension DateFormater on String? {
  String timeFormat() {
    if (this == null) return "";
    DateTime date = DateTime.parse(this!);
    return DateFormat("dd MMMM yyyy, HH:mm", "id_ID").format(date);
  }

  dateFormat() {
    if (this == null) return "";
    DateTime date = DateTime.parse(this!);
    return DateFormat("dd MMMM yyyy", "id_ID").format(date);
  }

  dateFormatWithDay() {
    if (this == null) return "";
    DateTime date = DateTime.parse(this!);
    return DateFormat("EEEE ,dd MMMM yyyy", "id_ID").format(date);
  }
}
