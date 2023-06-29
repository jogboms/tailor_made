import 'package:tailor_made/domain.dart';

class ImageStorageMockImpl implements ImageStorage {
  @override
  Future<ImageFileReference> createContactImage({required String path, required String userId}) async =>
      (src: '', path: '');

  @override
  Future<ImageFileReference> createReferenceImage({required String path, required String userId}) async =>
      (src: '', path: '');

  @override
  Future<bool> delete({required ImageFileReference reference, required String userId}) async => true;
}
