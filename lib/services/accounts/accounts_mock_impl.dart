import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/mock/models.dart';
import 'package:tailor_made/services/accounts/accounts.dart';

class AccountsMockImpl extends Accounts {
  @override
  Future<void> signInWithGoogle() async {
    // TODO
    return null;
  }

  @override
  Stream<MockUser> get onAuthStateChanged async* {
    yield const MockUser();
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
    yield AccountModel((b) => b
      ..uid = "1"
      ..notice = "Hello"
      ..phoneNumber = 123456789
      ..email = "jeremiah@gmail.com"
      ..displayName = "Jogboms"
      ..status = AccountModelStatus.enabled
      ..rating = 5
      ..hasPremiumEnabled = true
      ..hasReadNotice = false
      ..hasSendRating = true
      ..photoURL = "https://gravatar.com/jeremiahogbomo@gmail.com"
      ..storeName = "Jogboms");
  }
}
