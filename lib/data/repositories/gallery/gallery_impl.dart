import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class GalleryImpl extends Gallery {
  GalleryImpl({
    required this.firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final Firebase firebase;
  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'gallery';

  @override
  Stream<List<ImageEntity>> fetchAll(String userId) {
    return collection.fetchAll().where('userID', isEqualTo: userId).snapshots().map(
          (MapQuerySnapshot snap) => snap.docs
              .map((MapQueryDocumentSnapshot item) => deriveImageEntity(item.id, item.reference.path, item.data()))
              .toList(),
        );
  }

  @override
  Future<ImageFileReference> createFile({required String path, required String userId}) async {
    return firebase.storage.create('$userId/references', filePath: path);
  }

  @override
  Future<bool> deleteFile({required ImageFileReference reference, required String userId}) async {
    await firebase.storage.delete(src: reference.src);
    return true;
  }
}

ImageEntity deriveImageEntity(String id, String? path, DynamicMap data) {
  return ImageEntity(
    reference: ReferenceEntity(id: id, path: path ?? '${GalleryImpl.collectionName}/$id'),
    id: id,
    userID: data['userID'] as String,
    contactID: data['contactID'] as String,
    jobID: data['jobID'] as String,
    path: data['path'] as String,
    src: data['src'] as String,
    createdAt: DateTime.parse(data['createdAt'] as String),
  );
}

extension ImageEntityFirebaseExtension on ImageEntity {
  Map<String, Object> toJson() {
    return <String, Object>{
      'id': id,
      'userID': userID,
      'contactID': contactID,
      'jobID': jobID,
      'path': path,
      'src': src,
      'createdAt': createdAt.toUtc().toString(),
    };
  }
}
