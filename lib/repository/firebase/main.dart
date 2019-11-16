import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tailor_made/repository/firebase/auth.dart';
import 'package:tailor_made/repository/firebase/cloud_db.dart';
import 'package:tailor_made/repository/firebase/cloud_storage.dart';
import 'package:tailor_made/repository/main.dart';

class FirebaseRepository extends Repository {
  FirebaseRepository({@required this.db, @required this.storage, @required this.auth})
      : assert(db != null && storage != null && auth != null);

  final CloudDb db;
  final CloudStorage storage;
  final Auth auth;
}

FirebaseRepository factory() {
  return FirebaseRepository(
    db: CloudDb(Firestore.instance),
    storage: CloudStorage(FirebaseStorage.instance),
    auth: Auth(FirebaseAuth.instance, GoogleSignIn()),
  );
}
