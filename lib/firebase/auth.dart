import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tailor_made/firebase/models.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

class Auth {
  static User _user;

  static User setUser(User user) => _user = user;

  static User get getUser => _user;

  static Stream<User> get onAuthStateChanged => _auth.onAuthStateChanged.map((_user) => User(_user));

  static Future<User> signInWithGoogle() async {
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

    final _user = User(user);

    setUser(_user);
    return _user;
  }

  static Future<void> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
  }
}
