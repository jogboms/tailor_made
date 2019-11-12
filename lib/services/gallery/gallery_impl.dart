import 'dart:io';

import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/services/gallery/gallery.dart';

class GalleryImpl extends Gallery {
  @override
  Stream<List<ImageModel>> fetchAll() {
    return CloudDb.gallery
        .snapshots()
        .map((snap) => snap.documents.map((item) => ImageModel.fromJson(item.data)).toList());
  }

  @override
  Storage createFile(File file) {
    return Storage(CloudStorage.createReferenceImage()..putFile(file));
  }
}
