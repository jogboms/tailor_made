import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter_native_image/flutter_native_image.dart';

class MkImageUtils {
  MkImageUtils(this.file);

  final File file;

  Future<File> compress({int quality = 90, int percentage = 75}) {
    return FlutterNativeImage.compressImage(
      file.path,
      quality: quality,
      percentage: percentage,
    );
  }

  Future<File> resize({int width = 120}) async {
    final ImageProperties props = await FlutterNativeImage.getImageProperties(file.path);
    return FlutterNativeImage.compressImage(
      file.path,
      targetWidth: width,
      targetHeight: (props.height * width / props.width).round(),
    );
  }
}
