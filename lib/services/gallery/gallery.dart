import 'dart:io';

import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Gallery {
  Stream<List<ImageModel>> fetchAll(String userId);

  Storage createFile(File file, String userId);
}
