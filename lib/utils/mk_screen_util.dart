import 'dart:math' as math show min;

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class MkScreenUtil {
  factory MkScreenUtil() => _instance;

  MkScreenUtil._({@required BuildContext context, this.size}) : _mq = MediaQuery.of(context);

  static MkScreenUtil initialize({@required BuildContext context, Size size = Size.zero}) {
    assert(context != null);
    assert(size != null);
    return _instance = MkScreenUtil._(context: context, size: size);
  }

  static MkScreenUtil _instance;

  final MediaQueryData _mq;
  final Size size;

  double get screenWidth => _mq.size.width;

  double get screenHeight => _mq.size.height;

  double setWidth(double width) => width * screenWidth / size.width;

  double setHeight(double height) => height * screenHeight / size.height;

  double setSquare(double length) => math.min(setWidth(length), setHeight(length));

  @override
  String toString() {
    return '$runtimeType('
        'size: $size, '
        'pixelRatio: ${_mq.devicePixelRatio}, '
        'screenWidthDp: $screenWidth, '
        'screenHeightDp: $screenHeight, '
        ')';
  }
}

double sw(double width) => MkScreenUtil()?.setWidth(width) ?? width;

double sh(double height) => MkScreenUtil()?.setHeight(height) ?? height;

double ss(double length) => MkScreenUtil()?.setSquare(length) ?? length;
