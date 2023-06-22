import 'dart:io';

import '../entities.dart';
import 'file_storage_reference.dart';

abstract class Gallery {
  Stream<List<ImageEntity>> fetchAll(String userId);

  FileStorageReference? createFile(File file, String userId);
}
