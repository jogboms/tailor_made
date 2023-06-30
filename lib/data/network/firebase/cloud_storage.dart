import 'package:firebase_storage/firebase_storage.dart';
import 'package:universal_io/io.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  CloudStorage(this._instance);

  final FirebaseStorage _instance;

  Future<({String src, String path})> create(String directory, {required String filePath}) {
    final Reference ref = _instance.ref().child('$directory/${const Uuid().v4()}.jpg');

    return ref
        .putFile(File(filePath))
        .then((_) => ref.getDownloadURL())
        .then((String src) => (src: src, path: ref.fullPath));
  }

  Future<void> delete({required String src}) => _instance.refFromURL(src).delete();
}
