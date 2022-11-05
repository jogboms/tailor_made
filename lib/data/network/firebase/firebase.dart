import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import 'package:tailor_made/domain.dart';

import 'auth.dart';
import 'cloud_db.dart';
import 'cloud_storage.dart';

class FirebaseRepository implements Repository {
  const FirebaseRepository({required this.db, required this.auth, required this.storage});

  final CloudDb db;
  final Auth auth;
  final CloudStorage storage;
}

Future<FirebaseRepository> repositoryFactory() async {
  final Firebase instance = await Firebase.initialize(
    options: null,
  );

  return FirebaseRepository(
    db: instance.db,
    auth: instance.auth,
    storage: instance.storage,
  );
}

class Firebase {
  const Firebase._({required this.db, required this.auth, required this.storage});

  static Future<Firebase> initialize({
    required firebase.FirebaseOptions? options,
    @visibleForTesting String? name,
    @visibleForTesting FirebaseAuth? auth,
    @visibleForTesting FirebaseFirestore? firestore,
    @visibleForTesting GoogleSignIn? googleSignIn,
  }) async {
    await firebase.Firebase.initializeApp(name: name, options: options);

    return Firebase._(
      db: CloudDb(firestore ?? FirebaseFirestore.instance),
      auth: Auth(auth ?? FirebaseAuth.instance, googleSignIn ?? GoogleSignIn()),
      storage: CloudStorage(FirebaseStorage.instance),
    );
  }

  final CloudDb db;
  final Auth auth;
  final CloudStorage storage;
}
