import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/services/gallery.dart';

class GalleryMockImpl extends Gallery {
  @override
  Stream<List<ImageModel>> fetchAll() async* {
    // TODO
    yield null;
  }

  @override
  StorageReference createFile(File file) {
    // TODO
    return null;
  }
}
