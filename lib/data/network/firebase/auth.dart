import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'exception.dart';

class Auth {
  Auth(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  String? get getUser => _mapFirebaseUserToUser(_auth.currentUser);

  Stream<String?> get onAuthStateChanged => _auth.authStateChanges().map(_mapFirebaseUserToUser);

  Future<String> signInWithGoogle() async {
    try {
      GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();

      if (currentUser == null) {
        throw PlatformException(code: GoogleSignIn.kSignInCanceledError);
      }

      final GoogleSignInAuthentication auth = await currentUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      final UserCredential response = await _auth.signInWithCredential(credential);

      return response.user!.uid;
    } on FirebaseAuthException catch (e, stackTrace) {
      switch (e.code) {
        case 'invalid-email':
          Error.throwWithStackTrace(
            AppFirebaseAuthException(AppFirebaseAuthExceptionType.invalidEmail, email: e.email),
            stackTrace,
          );
        case 'user-disabled':
          Error.throwWithStackTrace(
            AppFirebaseAuthException(AppFirebaseAuthExceptionType.userDisabled, email: e.email),
            stackTrace,
          );
        case 'user-not-found':
          Error.throwWithStackTrace(
            AppFirebaseAuthException(AppFirebaseAuthExceptionType.userNotFound, email: e.email),
            stackTrace,
          );
        case 'too-many-requests':
          Error.throwWithStackTrace(
            AppFirebaseAuthException(AppFirebaseAuthExceptionType.tooManyRequests, email: e.email),
            stackTrace,
          );
      }
      Error.throwWithStackTrace(Exception(e.toString()), stackTrace);
    } on PlatformException catch (e, stackTrace) {
      switch (e.code) {
        case GoogleSignIn.kSignInCanceledError:
          Error.throwWithStackTrace(
            const AppFirebaseAuthException(AppFirebaseAuthExceptionType.canceled, email: null),
            stackTrace,
          );
        case GoogleSignIn.kSignInFailedError:
          Error.throwWithStackTrace(
            const AppFirebaseAuthException(AppFirebaseAuthExceptionType.failed, email: null),
            stackTrace,
          );
        case GoogleSignIn.kNetworkError:
          Error.throwWithStackTrace(
            const AppFirebaseAuthException(AppFirebaseAuthExceptionType.networkUnavailable, email: null),
            stackTrace,
          );
        case 'popup_blocked_by_browser':
          Error.throwWithStackTrace(
            const AppFirebaseAuthException(AppFirebaseAuthExceptionType.popupBlockedByBrowser, email: null),
            stackTrace,
          );
      }
      Error.throwWithStackTrace(Exception(e.toString()), stackTrace);
    }
  }

  Future<void> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  String? _mapFirebaseUserToUser(User? user) {
    if (user == null) {
      return null;
    }
    return user.uid;
  }
}
