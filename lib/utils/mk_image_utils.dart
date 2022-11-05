import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter_native_image/flutter_native_image.dart';

class MkImageUtils {
  MkImageUtils(this.path);

  final String path;

  Future<File> compress({int quality = 90, int percentage = 75}) {
    return FlutterNativeImage.compressImage(
      path,
      quality: quality,
      percentage: percentage,
    );
  }

  Future<File> resize({int width = 120}) async {
    final ImageProperties props = await FlutterNativeImage.getImageProperties(path);
    return FlutterNativeImage.compressImage(
      path,
      targetWidth: width,
      targetHeight: (props.height! * width / props.width!).round(),
    );
  }
}
