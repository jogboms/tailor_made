import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Auth {
  static FirebaseUser _user;
  Auth._();

  static FirebaseUser setUser(FirebaseUser user) => _user = user;
  static FirebaseUser get getUser => _user;

  static Future<GoogleSignInAccount> silently() async =>
      await _googleSignIn.signInSilently();

  static Stream<FirebaseUser> get onAuthStateChanged =>
      _auth.onAuthStateChanged;

  static Future<FirebaseUser> signInWithGoogle() async {
    try {
      // Attempt to get the currently authenticated user
      GoogleSignInAccount currentUser = _googleSignIn.currentUser;
      // Attempt to sign in without user interaction
      currentUser ??= await _googleSignIn.signInSilently();
      // Force the user to interactively sign in
      currentUser ??= await _googleSignIn.signIn();

      if (currentUser == null) {
        throw PlatformException(code: "canceled");
      }

      final GoogleSignInAuthentication auth = await currentUser.authentication;

      // Authenticate with firebase
      final FirebaseUser user = await _auth.signInWithGoogle(
        idToken: auth.idToken,
        accessToken: auth.accessToken,
      );
      assert(user != null);
      assert(!user.isAnonymous);

      setUser(user);
      return user;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Null> signOutWithGoogle() async {
    // Sign out with firebase
    await _auth.signOut();
    // Sign out with google
    await _googleSignIn.signOut();
    // Clear state
    _user = null;
  }
}
