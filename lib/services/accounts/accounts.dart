import 'package:firebase_auth/firebase_auth.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/models/account.dart';

abstract class Accounts {
  static Accounts di() => Injector.appInstance.getDependency<Accounts>();

  FirebaseUser get getUser;

  Future<FirebaseUser> signInWithGoogle();

  Future<FirebaseUser> get onAuthStateChanged;

  Future<Null> signout();

  Future<void> readNotice(AccountModel account);

  Future<void> sendRating(AccountModel account, int rating);

  Future<void> signUp(AccountModel account);

  Stream<AccountModel> getAccount();
}
