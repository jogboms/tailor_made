import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/utils/tm_theme.dart';

Widget loadingSpinner({Color color}) {
  return Center(
    child: SpinKitFadingFour(
      color: color ?? kAccentColor,
      // color: color ?? primarySwatch,
      size: 30.0,
    ),
  );
}
