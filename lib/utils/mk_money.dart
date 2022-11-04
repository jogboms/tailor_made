import 'package:intl/intl.dart';

// var nairaFormat = NumberFormat.currency(symbol: "₦");
// var nairaFormat = NumberFormat.currency(symbol: "\u20A6");
// var nairaFormat = NumberFormat.currency(symbol: "");
// final nairaFormat =
// NumberFormat.compactSimpleCurrency(name: "NGN", decimalDigits: 2);
// NumberFormat.compactCurrency(name: "", decimalDigits: 2);

const String _symbol = '₦';

class MkMoney {
  MkMoney(this.money, {bool isLong = false})
      : _format = isLong
            ? NumberFormat.simpleCurrency(name: _symbol, decimalDigits: 2)
            : NumberFormat.compactSimpleCurrency(name: _symbol, decimalDigits: 2);

  num? money;
  final NumberFormat _format;

  String get formatted {
    try {
      return _format.format(money ?? 0);
    } catch (e) {
      return '₦0.0';
    }
  }
}
