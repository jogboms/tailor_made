import 'package:tailor_made/domain.dart';

class GalleryMockImpl extends Gallery {
  @override
  Stream<List<ImageEntity>> fetchAll(String userId) async* {}

  @override
  Future<ImageFileReference> createFile({required String path, required String userId}) async {
    return (src: '', path: '');
  }

  @override
  Future<bool> deleteFile({required ImageFileReference reference, required String userId}) async {
    return true;
  }
}
