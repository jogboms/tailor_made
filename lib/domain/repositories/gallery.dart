import 'dart:io';

import '../entities.dart';
import '../models/image.dart';

abstract class Gallery {
  Stream<List<ImageModel?>> fetchAll(String userId);

  Storage? createFile(File file, String userId);
}
