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
  Stream<String?> get onAuthStateChanged async* {
    yield '1';
  }

  @override
  Future<void>? signOut() {
    return null;
  }

  @override
  Future<void> signUp(AccountEntity account) async {
    return;
  }

  @override
  Future<AccountEntity?> getAccount(String userId) async {
    return const AccountEntity(
      reference: ReferenceEntity(id: 'id', path: 'path'),
      uid: '1',
      notice: 'Hello',
      phoneNumber: 123456789,
      email: 'jeremiah@gmail.com',
      displayName: 'Jogboms',
      status: AccountStatus.enabled,
      rating: 5,
      hasPremiumEnabled: true,
      hasReadNotice: false,
      hasSendRating: true,
      photoURL: 'https://secure.gravatar.com/avatar/96b338e14ff9d18b1b2d6e5dc279a710',
      storeName: 'Jogboms',
    );
  }

  @override
  Future<bool> updateAccount(
    String userId, {
    required String id,
    required String path,
    String? storeName,
    bool? hasSendRating,
    int? rating,
    bool? hasReadNotice,
  }) async {
    return true;
  }
}
