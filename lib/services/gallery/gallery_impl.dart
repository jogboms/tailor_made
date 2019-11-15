import 'dart:io';

import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/gallery/gallery.dart';
import 'package:tailor_made/services/session.dart';

class GalleryImpl extends Gallery<FirebaseRepository> {
  @override
  Stream<List<ImageModel>> fetchAll() {
    return repository.db
        .gallery(Session.di().getUserId())
        .snapshots()
        .map((snap) => snap.documents.map((item) => ImageModel.fromJson(item.data)).toList());
  }

  @override
  FireStorage createFile(File file) {
    return FireStorage(repository.storage.createReferenceImage((Session.di().getUserId()))..putFile(file));
  }
}
