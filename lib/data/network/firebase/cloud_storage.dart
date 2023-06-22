import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  CloudStorage(this._instance);

  final FirebaseStorage _instance;

  Reference ref(String path) => _instance.ref().child(path).child('${const Uuid().v1()}.jpg');
}
