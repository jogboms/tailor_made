import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class ImageStorageImpl implements ImageStorage {
  ImageStorageImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Future<ImageFileReference> createContactImage({required String path, required String userId}) {
    return firebase.storage.create('$userId/contacts', filePath: path);
  }

  @override
  Future<ImageFileReference> createReferenceImage({required String path, required String userId}) {
    return firebase.storage.create('$userId/references', filePath: path);
  }

  @override
  Future<bool> delete({required ImageFileReference reference, required String userId}) async {
    await firebase.storage.delete(src: reference.src);
    return true;
  }
}
