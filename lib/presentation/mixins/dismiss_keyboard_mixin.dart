import 'package:flutter/widgets.dart';

abstract class DismissKeyboardMixin {
  BuildContext get context;

  void closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}
