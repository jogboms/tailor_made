import '../entities.dart';

abstract class Gallery {
  Stream<List<ImageEntity>> fetchAll(String userId);

  Future<ImageFileReference> createFile({required String path, required String userId});

  Future<bool> deleteFile({required ImageFileReference reference, required String userId});
}
