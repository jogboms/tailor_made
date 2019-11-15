import 'package:injector/injector.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/repository/models.dart';

abstract class Accounts<T extends Repository> {
  Accounts() : repository = Injector.appInstance.getDependency<Repository>();

  final T repository;

  static Accounts di() => Injector.appInstance.getDependency<Accounts>();

  Future<User> signInWithGoogle();

  Future<User> get onAuthStateChanged;

  Future<void> signout();

  Future<void> readNotice(AccountModel account);

  Future<void> sendRating(AccountModel account, int rating);

  Future<void> signUp(AccountModel account);

  Stream<AccountModel> getAccount();
}
