import 'package:flutter/widgets.dart';

abstract class MkTabletAwareProvider {
  BuildContext get context;

  bool get isTablet {
    return MediaQuery.of(context).size.shortestSide < 600;
  }
}
