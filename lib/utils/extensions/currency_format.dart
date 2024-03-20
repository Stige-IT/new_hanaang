import 'package:intl/intl.dart';

extension CurrencyFormat on int {
  convertToIdr() {
    NumberFormat currencyFormatter = NumberFormat.currency(
      name: "Rp",
      locale: 'ID_id',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormatter.format(this);
  }
}
