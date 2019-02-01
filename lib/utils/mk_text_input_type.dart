import 'package:flutter/services.dart';

class MkTextInputType {
  static const TextInputType number = TextInputType.numberWithOptions(
    decimal: true,
    signed: true,
  );
}
