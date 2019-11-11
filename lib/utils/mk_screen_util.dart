import 'dart:math' show min;

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class MkScreenUtilConfig {
  const MkScreenUtilConfig({this.width = 1080, this.height = 1920, this.allowFontScaling = false});

  final double width;
  final double height;
  final bool allowFontScaling;
}

class MkScreenUtil {
  factory MkScreenUtil() => _instance;

  MkScreenUtil._({@required BuildContext context, this.config}) : mq = MediaQuery.of(context);

  static MkScreenUtil initialize({
    @required BuildContext context,
    MkScreenUtilConfig config = const MkScreenUtilConfig(),
  }) {
    assert(config != null);
    return _instance ??= MkScreenUtil._(context: context, config: config);
  }

  static MkScreenUtil _instance;

  final MediaQueryData mq;
  final MkScreenUtilConfig config;

  double get textScaleFactor => mq.textScaleFactor;
  double get pixelRatio => mq.devicePixelRatio;
  double get screenWidthDp => mq.size.width;
  double get screenHeightDp => mq.size.height;
  double get screenWidth => screenWidthDp * pixelRatio;
  double get screenHeight => screenHeightDp * pixelRatio;
  EdgeInsets get safeArea => mq.padding;
  double get statusBarHeight => safeArea.top * pixelRatio;
  double get bottomBarHeight => safeArea.bottom * pixelRatio;
  double get keyboardHeight => mq.viewInsets.bottom;

  double setWidth(double width) => width * screenWidthDp / config.width;
  double setHeight(double height) => height * screenHeightDp / config.height;
  double setSquare(double length) => min(setWidth(length), setHeight(length));
  double setFont(double fontSize) =>
      config.allowFontScaling ? setWidth(fontSize) : setWidth(fontSize) / textScaleFactor;

  @override
  String toString() {
    return '$runtimeType('
        'textScaleFactor: $textScaleFactor, '
        'pixelRatio: $pixelRatio, '
        'screenWidthDp: $screenWidthDp, '
        'screenHeightDp: $screenHeightDp, '
        'screenWidth: $screenWidth, '
        'screenHeight: $screenHeight, '
        'safeArea: $safeArea, '
        'statusBarHeight: $statusBarHeight, '
        'bottomBarHeight: $bottomBarHeight, '
        'keyboardHeight: $keyboardHeight'
        ')';
  }
}

double sw(double width) => MkScreenUtil()?.setWidth(width) ?? width;

double sh(double height) => MkScreenUtil()?.setHeight(height) ?? height;

double ss(double length) => MkScreenUtil()?.setSquare(length) ?? length;

double sf(double fontSize) => MkScreenUtil()?.setFont(fontSize) ?? fontSize;
