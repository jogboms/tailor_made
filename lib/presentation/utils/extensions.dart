import 'package:flutter/widgets.dart';
import 'package:tailor_made/core.dart';

extension L10nExtensions on BuildContext {
  L10n get l10n => L10n.of(this);
}
