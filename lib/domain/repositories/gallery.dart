import 'dart:io';

import '../entities.dart';

abstract class Gallery {
  Stream<List<ImageEntity>> fetchAll(String userId);

  Storage? createFile(File file, String userId);
}
