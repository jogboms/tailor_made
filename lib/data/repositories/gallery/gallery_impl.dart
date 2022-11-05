import 'dart:io';

import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class GalleryImpl extends Gallery {
  GalleryImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<ImageModel?>> fetchAll(String userId) {
    return repository.db.gallery(userId).snapshots().map(
          (MapQuerySnapshot snap) =>
              snap.docs.map((MapQueryDocumentSnapshot item) => ImageModel.fromJson(item.data())).toList(),
        );
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createReferenceImage(userId)..putFile(file));
  }
}
