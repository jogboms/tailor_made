import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  CloudStorage(this._instance);

  final FirebaseStorage _instance;

  StorageReference createContactImage(String userId) =>
      _instance.ref().child('$userId/contacts').child('${Uuid().v1()}.jpg');

  StorageReference createReferenceImage(String userId) =>
      _instance.ref().child('$userId/references').child('${Uuid().v1()}.jpg');
}
