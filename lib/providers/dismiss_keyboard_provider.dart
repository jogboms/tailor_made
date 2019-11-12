import 'package:flutter/widgets.dart';

abstract class DismissKeyboardProvider {
  BuildContext get context;

  void closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());
}
