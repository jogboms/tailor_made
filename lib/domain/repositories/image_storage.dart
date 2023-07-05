import '../entities/image_file_reference.dart';

abstract class ImageStorage {
  Future<ImageFileReference> createContactImage({required String path, required String userId});

  Future<ImageFileReference> createReferenceImage({required String path, required String userId});

  Future<bool> delete({required ImageFileReference reference, required String userId});
}
