import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/models/image.dart';

class Gallery {
  static Stream<List<ImageModel>> fetchAll() {
    return CloudDb.gallery.snapshots().map(
          (snap) => snap.documents
              .map((item) => ImageModel.fromJson(item.data))
              .toList(),
        );
  }

  static StorageReference createFile(File file) {
    return CloudStorage.createReferenceImage()..putFile(file);
  }
}
