import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart' as firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';

import 'analytics.dart';
import 'auth.dart';
import 'cloud_db.dart';
import 'cloud_storage.dart';
import 'crashlytics.dart';

class Firebase {
  const Firebase._({
    required this.db,
    required this.auth,
    required this.storage,
    required this.crashlytics,
    required this.analytics,
  });

  static Future<Firebase> initialize({
    required firebase.FirebaseOptions? options,
    required bool isAnalyticsEnabled,
    @visibleForTesting String? name,
    @visibleForTesting FirebaseAnalytics? analytics,
    @visibleForTesting FirebaseAuth? auth,
    @visibleForTesting FirebaseFirestore? firestore,
    @visibleForTesting FirebaseCrashlytics? crashlytics,
    @visibleForTesting GoogleSignIn? googleSignIn,
  }) async {
    await firebase.Firebase.initializeApp(name: name, options: options);

    // coverage:ignore-start, somehow no way to cover this line
    final FirebaseAnalytics firebaseAnalytics = analytics ?? FirebaseAnalytics.instance;
    // coverage:ignore-end
    await firebaseAnalytics.setAnalyticsCollectionEnabled(isAnalyticsEnabled);

    return Firebase._(
      db: CloudDb(firestore ?? FirebaseFirestore.instance),
      auth: Auth(auth ?? FirebaseAuth.instance, googleSignIn ?? GoogleSignIn()),
      storage: CloudStorage(FirebaseStorage.instance),
      crashlytics: Crashlytics(crashlytics ?? FirebaseCrashlytics.instance),
      analytics: CloudAnalytics(firebaseAnalytics),
    );
  }

  final CloudDb db;
  final Auth auth;
  final CloudStorage storage;
  final Crashlytics crashlytics;
  final CloudAnalytics analytics;
}
