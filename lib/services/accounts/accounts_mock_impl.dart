import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/services/accounts/accounts.dart';

class AccountsMockImpl extends Accounts<MockRepository> {
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
