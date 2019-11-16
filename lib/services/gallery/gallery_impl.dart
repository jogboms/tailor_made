import 'dart:io';

import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/gallery/gallery.dart';

class GalleryImpl extends Gallery {
  GalleryImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ImageModel>> fetchAll(String userId) {
    return repository.db
        .gallery(userId)
        .snapshots()
        .map((snap) => snap.documents.map((item) => ImageModel.fromJson(item.data)).toList());
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createReferenceImage(userId)..putFile(file));
  }
}
