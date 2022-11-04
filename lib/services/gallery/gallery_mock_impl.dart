import 'dart:io';

import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/services/gallery/gallery.dart';

class GalleryMockImpl extends Gallery {
  @override
  Stream<List<ImageModel>> fetchAll(String userId) async* {}

  @override
  Storage? createFile(File file, String userId) {
    return null;
  }
}
