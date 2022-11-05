import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tailor_made/core.dart';

import 'models.dart';

class Auth {
  Auth(this._auth, this._googleSignIn);

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FireUser get getUser => _mapFirebaseUserToUser(_auth.currentUser);

  Stream<FireUser> get onAuthStateChanged => _auth.authStateChanges().map(_mapFirebaseUserToUser);

  Future<void> signInWithGoogle() async {
    try {
      GoogleSignInAccount? currentUser = _googleSignIn.currentUser;
      currentUser ??= await _googleSignIn.signInSilently();
      currentUser ??= await _googleSignIn.signIn();

      if (currentUser == null) {
        throw PlatformException(code: GoogleSignIn.kSignInCanceledError);
      }

      final GoogleSignInAuthentication auth = await currentUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      await _auth.signInWithCredential(credential);
    } on PlatformException catch (e) {
      if (e.code == GoogleSignIn.kSignInCanceledError) {
        return;
      }
      if (e.message?.contains('administrator') ?? false) {
        throw Exception('It seems this account has been disabled. Contact an Admin.');
      }
      if (_containsAny(e.message, <String>['NETWORK_ERROR', 'network'])) {
        throw const NoInternetException();
      }
      throw Exception('Sorry, We could not connect. Try again.');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOutWithGoogle() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  FireUser _mapFirebaseUserToUser(User? user) {
    assert(user != null);
    return FireUser(user);
  }
}

bool _containsAny(String? value, List<String> find) =>
    find.fold(false, (bool acc, String cur) => value?.contains(cur) ?? false);
