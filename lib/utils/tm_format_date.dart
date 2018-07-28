import 'package:intl/intl.dart';

String formatDate(
  DateTime date, {
  String day = "EEE",
  String month = "MMM",
  String year = "yy",
}) {
  var suffix = "th";
  final digit = date.day % 10;
  if ((digit > 0 && digit < 4) && (date.day < 11 || date.day > 13)) {
    suffix = ["st", "nd", "rd"][digit - 1];
  }
  return new DateFormat("$day, d'$suffix' $month, $year").format(date);
}
