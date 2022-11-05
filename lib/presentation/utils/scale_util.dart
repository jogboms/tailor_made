import 'package:flutter/widgets.dart';

class ScaleUtil {
  factory ScaleUtil() {
    if (_instance == null) {
      throw Exception('MkScaleUtil.initialize has to be called first');
    }
    return _instance!;
  }

  ScaleUtil._({required BuildContext context, this.size}) : _mq = MediaQuery.of(context);

  static ScaleUtil initialize({required BuildContext context, Size size = Size.zero}) {
    return _instance = ScaleUtil._(context: context, size: size);
  }

  static ScaleUtil? _instance;
  final MediaQueryData _mq;
  final Size? size;

  double get screenWidth => _mq.size.width;

  double get screenHeight => _mq.size.height;

  double x(double width) => width * screenWidth / size!.width;

  double y(double height) => height * screenHeight / size!.height;

  double xy(double length) => length * _mq.size.shortestSide / size!.shortestSide;

  @override
  String toString() => '$runtimeType('
      'size: $size, '
      'screenWidth: $screenWidth, '
      'screenHeight: $screenHeight'
      ')';
}

double sx(double width) => ScaleUtil().x(width);

double sy(double height) => ScaleUtil().y(height);

double sxy(double length) => ScaleUtil().xy(length);
