import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/services/auth.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

class CloudStorage {
  static FirebaseStorage instance = FirebaseStorage.instance;

  CloudStorage._();

  static String get authUserId => Auth.getUser?.uid ?? "0";

  static StorageReference get contacts =>
      instance.ref().child('$authUserId/contacts');
  static StorageReference get references =>
      instance.ref().child('$authUserId/references');

  static StorageReference createContactImage([String id]) =>
      contacts.child('${id ?? uuid()}.jpg');
  static StorageReference createReferenceImage([String id]) =>
      references.child('${id ?? uuid()}.jpg');
}
