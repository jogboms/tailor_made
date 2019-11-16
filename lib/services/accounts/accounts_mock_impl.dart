import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/services/accounts/accounts.dart';

class AccountsMockImpl extends Accounts {
  @override
  Future<User> signInWithGoogle() async {
    // TODO
    return null;
  }

  @override
  Future<User> get onAuthStateChanged async {
    // TODO
    return null;
  }

  @override
  Future<void> signout() {
    // TODO
    return null;
  }

  @override
  Future<void> readNotice(AccountModel account) async {
    // TODO
    return null;
  }

  @override
  Future<void> sendRating(AccountModel account, int rating) async {
    // TODO
    return null;
  }

  @override
  Future<void> signUp(AccountModel account, String notice) async {
    // TODO
    return null;
  }

  @override
  Stream<AccountModel> getAccount(String userId) async* {
    // TODO
    yield null;
  }
}
