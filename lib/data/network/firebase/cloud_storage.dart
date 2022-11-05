import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  CloudStorage(this._instance);

  final FirebaseStorage _instance;

  Reference createContactImage(String userId) =>
      _instance.ref().child('$userId/contacts').child('${const Uuid().v1()}.jpg');

  Reference createReferenceImage(String userId) =>
      _instance.ref().child('$userId/references').child('${const Uuid().v1()}.jpg');
}
