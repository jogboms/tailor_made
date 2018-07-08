import 'package:intl/intl.dart';

final nairaFormat = new NumberFormat.compactSimpleCurrency(name: "NGN", decimalDigits: 1);

String formatNaira(double amount) {
  return nairaFormat.format(amount ?? 0);
}
