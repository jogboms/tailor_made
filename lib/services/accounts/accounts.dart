import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Accounts {
  Future<User> signInWithGoogle();

  Future<User> get onAuthStateChanged;

  Future<void> signout();

  Future<void> readNotice(AccountModel account);

  Future<void> sendRating(AccountModel account);

  Future<void> signUp(AccountModel account);

  Stream<AccountModel> getAccount(String userId);
}
