import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Auth {
  static FirebaseUser _user;

  static FirebaseUser setUser(FirebaseUser user) => _user = user;
  static FirebaseUser get getUser => _user;

  static Future<GoogleSignInAccount> silently() async => await _googleSignIn.signInSilently();

  static Stream<FirebaseUser> get onAuthStateChanged => _auth.onAuthStateChanged;

  static Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount currentUser = _googleSignIn.currentUser;
    currentUser ??= await _googleSignIn.signInSilently();
    currentUser ??= await _googleSignIn.signIn();

    if (currentUser == null) {
      throw PlatformException(code: "canceled");
    }

    final GoogleSignInAuthentication auth = await currentUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    final FirebaseUser user = await _auth.signInWithCredential(credential);
    assert(user != null);
    assert(!user.isAnonymous);

    setUser(user);
    return user;
  }

  static Future<Null> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
  }
}
