class MkTimes {
  MkTimes(this.date, {bool isLong = false}) {
    if (date == null) {
      return;
    }
    _ext = (isLong ? ":${date.minute}".padRight(3, "0") : "") + (date.hour > 12 ? "pm" : "am");
  }

  DateTime date;
  String _ext;

  String get format =>
      date == null ? null : (date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour)).toString() + _ext;
}
