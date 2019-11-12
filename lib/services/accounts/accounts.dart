import 'package:injector/injector.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/account.dart';

abstract class Accounts {
  static Accounts di() => Injector.appInstance.getDependency<Accounts>();

  User get getUser;

  Future<User> signInWithGoogle();

  Future<User> get onAuthStateChanged;

  Future<void> signout();

  Future<void> readNotice(AccountModel account);

  Future<void> sendRating(AccountModel account, int rating);

  Future<void> signUp(AccountModel account);

  Stream<AccountModel> getAccount();
}
