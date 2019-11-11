import 'package:intl/intl.dart';

class MkDates {
  MkDates(this.date, {String day = "EEE", String month = "MMM", String year = "yy"}) {
    if (date == null) {
      return;
    }
    var suffix = "th";
    final digit = date.day % 10;
    if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
      suffix = ["st", "nd", "rd"][digit - 1];
    }
    _format = DateFormat("d'$suffix' $month, $year");
  }

  MkDates.withFormat(this.date, this._format);

  DateTime date;
  DateFormat _format;

  String get formatted => date == null ? null : _format.format(date);
}
