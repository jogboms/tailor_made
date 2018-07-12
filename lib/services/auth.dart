import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = new GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Auth {
  static FirebaseUser _user;
  Auth._();

  static getUser() => _user;

  static Future<GoogleSignInAccount> silently() async => await _googleSignIn.signInSilently();

  static get onAuthStateChanged => _auth.onAuthStateChanged;

  static Future<FirebaseUser> signInWithGoogle() async {
    // Attempt to get the currently authenticated user
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;
    if (currentUser == null) {
      // Attempt to sign in without user interaction
      currentUser = await _googleSignIn.signInSilently();
    }
    if (currentUser == null) {
      // Force the user to interactively sign in
      currentUser = await _googleSignIn.signIn();
    }

    final GoogleSignInAuthentication auth = await currentUser.authentication;

    // Authenticate with firebase
    final FirebaseUser user = await _auth.signInWithGoogle(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );

    assert(user != null);
    assert(!user.isAnonymous);

    _user = user;
    return user;
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
