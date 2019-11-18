import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/mock/models.dart';
import 'package:tailor_made/services/accounts/accounts.dart';

class AccountsMockImpl extends Accounts {
  @override
  Future<MockUser> signInWithGoogle() async => const MockUser();

  @override
  Future<MockUser> get onAuthStateChanged async => const MockUser();

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
  Future<void> sendRating(AccountModel account) async {
    // TODO
    return null;
  }

  @override
  Future<void> signUp(AccountModel account) async {
    // TODO
    return null;
  }

  @override
  Stream<AccountModel> getAccount(String userId) async* {
    // TODO
    yield null;
  }
}
