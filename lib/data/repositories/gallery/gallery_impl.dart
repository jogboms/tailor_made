import 'dart:io';

import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class GalleryImpl extends Gallery {
  GalleryImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Stream<List<ImageModel>> fetchAll(String userId) {
    return firebase.db.gallery(userId).snapshots().map(
          (MapQuerySnapshot snap) =>
              snap.docs.map((MapQueryDocumentSnapshot item) => ImageModel.fromJson(item.data())).toList(),
        );
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(firebase.storage.createReferenceImage(userId)..putFile(file));
  }
}
