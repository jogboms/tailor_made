import 'package:flutter/material.dart';

abstract class MkDrawerProvider {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showDrawer() {
    scaffoldKey.currentState.openDrawer();
  }
}
