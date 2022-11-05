import '../entities.dart';
import '../models/account.dart';

abstract class Accounts {
  Future<void> signInWithGoogle();

  Stream<User> get onAuthStateChanged;

  Future<void>? signOut();

  Future<void> readNotice(AccountModel account);

  Future<void> sendRating(AccountModel account);

  Future<void> signUp(AccountModel account);

  Stream<AccountModel> getAccount(String? userId);
}
