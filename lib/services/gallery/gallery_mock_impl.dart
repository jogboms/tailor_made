import 'dart:io';

import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/services/gallery/gallery.dart';

class GalleryMockImpl extends Gallery {
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
