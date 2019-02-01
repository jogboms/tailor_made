import 'package:flutter/material.dart';

abstract class MkPlatformAwareProvider {
  BuildContext get context;

  bool get isIos {
    return Theme.of(context).platform == TargetPlatform.iOS;
  }

  bool get isAndroid => !isIos;
}
