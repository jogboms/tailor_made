import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:intl/intl.dart';

export 'package:flutter_gen/gen_l10n/l10n.dart';

extension L10nExtensions on BuildContext {
  L10n get l10n => L10n.of(this);
}

extension MonthShortNamesExtension on L10n {
  List<String> get monthsShortNames => DateFormat().dateSymbols.SHORTMONTHS;
}

extension SystemOverlayStyleExtensions on Brightness {
  SystemUiOverlayStyle get systemOverlayStyle =>
      this == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light;
}
