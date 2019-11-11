import 'package:flutter/widgets.dart';

abstract class MkKeyboardProvider {
  BuildContext get context;

  void closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}
