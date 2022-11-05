import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/gallery/gallery.dart';

class GalleryImpl extends Gallery {
  GalleryImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ImageModel?>> fetchAll(String userId) {
    return repository.db.gallery(userId).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snap) => snap.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> item) => ImageModel.fromJson(item.data()))
              .toList(),
        );
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createReferenceImage(userId)..putFile(file));
  }
}
