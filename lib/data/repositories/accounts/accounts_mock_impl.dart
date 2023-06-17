import 'package:tailor_made/domain.dart';

class MockUser implements User {
  const MockUser([this.uid = '1']);

  @override
  final String uid;
}

class AccountsMockImpl extends Accounts {
  @override
  Future<void> signInWithGoogle() async {
    return;
  }

  @override
  Stream<User?> get onAuthStateChanged async* {
    yield const MockUser();
  }

  @override
  Future<void>? signOut() {
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
    yield const AccountModel(
      uid: '1',
      notice: 'Hello',
      phoneNumber: 123456789,
      email: 'jeremiah@gmail.com',
      displayName: 'Jogboms',
      status: AccountModelStatus.enabled,
      rating: 5,
      hasPremiumEnabled: true,
      hasReadNotice: false,
      hasSendRating: true,
      photoURL: 'https://secure.gravatar.com/avatar/96b338e14ff9d18b1b2d6e5dc279a710',
      storeName: 'Jogboms',
    );
  }
}
