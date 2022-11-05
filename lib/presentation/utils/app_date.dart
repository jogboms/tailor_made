import 'package:intl/intl.dart';

class AppDate {
  AppDate(this.date, {String day = 'EEE', String month = 'MMM', String year = 'yy'}) {
    if (date == null) {
      _format = null;
      return;
    }
    String suffix = 'th';
    final int digit = date!.day % 10;
    if ((digit > 0 && digit < 4) && (date!.day < 11 || date!.day > 13)) {
      suffix = <String>['st', 'nd', 'rd'][digit - 1];
    }
    _format = DateFormat("d'$suffix' $month, $year");
  }

  AppDate.withFormat(this.date, this._format);

  DateTime? date;
  late DateFormat? _format;

  String? get formatted => date == null ? null : _format!.format(date!);
}
