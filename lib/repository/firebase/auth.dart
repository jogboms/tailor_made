import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/repository/models.dart';

class Auth {
  Auth(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  Future<User> get getUser => _auth.currentUser().then(_mapFirebaseUserToUser);

  Stream<User> get onAuthStateChanged => _auth.onAuthStateChanged.map(_mapFirebaseUserToUser);

  Future<User> signInWithGoogle() async {
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

    return _mapFirebaseUserToUser(user);
  }

  Future<void> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  User _mapFirebaseUserToUser(FirebaseUser _user) => FireUser(_user);
}
