import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/firebase/auth.dart';
import 'package:uuid/uuid.dart';

class CloudStorage {
  static final FirebaseStorage _instance = FirebaseStorage.instance;

  static String get _authUserId => Auth.getUser?.uid ?? "0";

  static StorageReference get contacts => _instance.ref().child('$_authUserId/contacts');

  static StorageReference get references => _instance.ref().child('$_authUserId/references');

  static StorageReference createContactImage([String id]) => contacts.child('${id ?? Uuid().v1()}.jpg');

  static StorageReference createReferenceImage([String id]) => references.child('${id ?? Uuid().v1()}.jpg');
}
