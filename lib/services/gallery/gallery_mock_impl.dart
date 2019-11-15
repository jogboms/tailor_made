import 'dart:io';

import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/services/gallery/gallery.dart';

class GalleryMockImpl extends Gallery<MockRepository> {
  @override
  Stream<List<ImageModel>> fetchAll() async* {
    // TODO
    yield null;
  }

  @override
  Storage createFile(File file) {
    // TODO
    return null;
  }
}
