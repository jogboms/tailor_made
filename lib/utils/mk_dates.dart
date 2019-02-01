import 'package:intl/intl.dart';

class MkDates {
  MkDates(
    this.date, {
    String day = "EEE",
    String month = "MMM",
    String year = "yy",
  }) {
    if (date == null) {
      return;
    }
    var suffix = "th";
    final digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    // _dfmt = DateFormat("$day, d'$suffix' $month, $year");
    _dfmt = DateFormat("d'$suffix' $month, $year");
  }

  DateTime date;
  DateFormat _dfmt;

  String get format => date == null ? null : _dfmt.format(date);
}
