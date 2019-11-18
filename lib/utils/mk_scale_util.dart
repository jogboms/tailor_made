import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

class MkScaleUtil {
  factory MkScaleUtil() {
    if (_instance == null) {
      throw Exception("MkScaleUtil.initialize has to be called first");
    }
    return _instance;
  }

  MkScaleUtil._({@required BuildContext context, this.size}) : _mq = MediaQuery.of(context);

  static MkScaleUtil initialize({@required BuildContext context, Size size = Size.zero}) {
    assert(context != null);
    assert(size != null);
    return _instance = MkScaleUtil._(context: context, size: size);
  }

  static MkScaleUtil _instance;
  final MediaQueryData _mq;
  final Size size;

  double get screenWidth => _mq.size.width;

  double get screenHeight => _mq.size.height;

  double x(double width) => width * screenWidth / size.width;

  double y(double height) => height * screenHeight / size.height;

  double xy(double length) => length * _mq.size.shortestSide / size.shortestSide;

  @override
  String toString() => '$runtimeType('
      'size: $size, '
      'screenWidth: $screenWidth, '
      'screenHeight: $screenHeight'
      ')';
}

double sx(double width) => MkScaleUtil().x(width);

double sy(double height) => MkScaleUtil().y(height);

double sxy(double length) => MkScaleUtil().xy(length);
