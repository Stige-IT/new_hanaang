import 'package:intl/intl.dart';

const _locale = 'id_ID';

String formatNumber(String? s) {
  if (s == null) return '';
  return NumberFormat.decimalPattern(_locale).format(int.parse(s));
}
