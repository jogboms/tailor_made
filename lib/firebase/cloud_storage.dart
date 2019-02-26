import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/firebase/auth.dart';
import 'package:tailor_made/utils/mk_uuid.dart';

class CloudStorage {
  CloudStorage._();

  static FirebaseStorage instance = FirebaseStorage.instance;

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
