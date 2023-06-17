import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

export 'package:flutter_gen/gen_l10n/l10n.dart';

extension L10nExtensions on BuildContext {
  L10n get l10n => L10n.of(this);
}
