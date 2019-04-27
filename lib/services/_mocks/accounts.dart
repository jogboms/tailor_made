import 'package:firebase_auth/firebase_auth.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/services/accounts.dart';

class AccountsMockImpl extends Accounts {
  @override
  FirebaseUser get getUser {
    // TODO
    return null;
  }

  @override
  Future<FirebaseUser> signInWithGoogle() async {
    // TODO
    return null;
  }

  @override
  Future<FirebaseUser> get onAuthStateChanged async {
    // TODO
    return null;
  }

  @override
  Future<Null> signout() {
    // TODO
    return null;
  }

  @override
  Future<void> readNotice(AccountModel account) async {
    // TODO
    return null;
  }

  @override
  Future<void> sendRating(
    AccountModel account,
    int rating,
  ) async {
    // TODO
    return null;
  }

  @override
  Future<void> signUp(AccountModel account) async {
    // TODO
    return null;
  }

  @override
  Stream<AccountModel> getAccount() async* {
    // TODO
    yield null;
  }
}
