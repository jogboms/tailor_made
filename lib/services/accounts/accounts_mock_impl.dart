import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/mock/models.dart';
import 'package:tailor_made/services/accounts/accounts.dart';

class AccountsMockImpl extends Accounts {
  @override
  Future<void> signInWithGoogle() async {
    return;
  }

  @override
  Stream<MockUser> get onAuthStateChanged async* {
    yield const MockUser();
  }

  @override
  Future<void>? signout() {
    return null;
  }

  @override
  Future<void> readNotice(AccountModel account) async {
    return;
  }

  @override
  Future<void> sendRating(AccountModel account) async {
    return;
  }

  @override
  Future<void> signUp(AccountModel account) async {
    return;
  }

  @override
  Stream<AccountModel> getAccount(String? userId) async* {
    yield AccountModel(
      (AccountModelBuilder b) => b
        ..uid = '1'
        ..notice = 'Hello'
        ..phoneNumber = 123456789
        ..email = 'jeremiah@gmail.com'
        ..displayName = 'Jogboms'
        ..status = AccountModelStatus.enabled
        ..rating = 5
        ..hasPremiumEnabled = true
        ..hasReadNotice = false
        ..hasSendRating = true
        ..photoURL = 'https://gravatar.com/jeremiahogbomo@gmail.com'
        ..storeName = 'Jogboms',
    );
  }
}
