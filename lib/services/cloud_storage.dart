import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class CloudStorage {
  static FirebaseStorage instance = FirebaseStorage.instance;

  CloudStorage._();

  static StorageReference get contacts =>
      instance.ref().child('${Auth.getUser.uid}/contacts');
  static StorageReference get references =>
      instance.ref().child('${Auth.getUser.uid}/references');

  static StorageReference createContact([String id]) =>
      contacts.child('${id ?? uuid()}.jpg');
  static StorageReference createReference([String id]) =>
      references.child('${id ?? uuid()}.jpg');
}
