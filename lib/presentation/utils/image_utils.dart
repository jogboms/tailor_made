import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter_native_image/flutter_native_image.dart';

class ImageUtils {
  ImageUtils(this.path);

  final String path;

  Future<File> resize({int width = 120}) async {
    final ImageProperties props = await FlutterNativeImage.getImageProperties(path);
    return FlutterNativeImage.compressImage(
      path,
      targetWidth: width,
      targetHeight: (props.height! * width / props.width!).round(),
    );
  }
}
