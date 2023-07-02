import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class AccountsImpl extends Accounts {
  AccountsImpl({
    required this.firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final Firebase firebase;
  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'accounts';

  @override
  Future<void> signIn() => firebase.auth.signInWithGoogle();

  @override
  Stream<String?> get onAuthStateChanged => firebase.auth.onAuthStateChanged;

  @override
  Future<void> signOut() => firebase.auth.signOutWithGoogle();

  @override
  Future<String> signUp(AccountEntity account) async {
    final Map<String, Object?> data = <String, Object?>{
      'uid': account.uid,
      'storeName': account.storeName,
      'email': account.email,
      'displayName': account.displayName,
      'phoneNumber': account.phoneNumber,
      'photoURL': account.photoURL,
      'status': account.status.index,
      'hasPremiumEnabled': account.hasPremiumEnabled,
      'hasSendRating': account.hasSendRating,
      'rating': account.rating,
      'notice': account.notice,
      'hasReadNotice': account.hasReadNotice,
    };
    await collection.fetchOne(account.uid).set(data);
    await firebase.db.collection('premium').doc(account.uid).set(data);
    return account.uid;
  }

  @override
  Future<AccountEntity> fetch() async {
    final String? id = firebase.auth.getUser;
    if (id == null) {
      throw const AuthException.userNotFound();
    }

    final AccountEntity? account = await getAccount(id);
    if (account == null) {
      throw const AuthException.userNotFound();
    }

    return account;
  }

  @override
  Future<AccountEntity?> getAccount(String userId) async {
    final MapDocumentSnapshot doc = await collection.fetchOne(userId).get();
    if (!doc.exists) {
      return null;
    }

    return _deriveAccountEntity(doc.id, doc.reference.path, doc.data()!);
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
    await collection.fetchOne(userId).update(<String, Object?>{
      if (storeName != null) 'storeName': storeName,
      if (hasSendRating != null) 'hasSendRating': hasSendRating,
      if (rating != null) 'rating': rating,
      if (hasReadNotice != null) 'hasReadNotice': hasReadNotice,
    });
    return true;
  }
}

AccountEntity _deriveAccountEntity(String id, String path, DynamicMap data) {
  return AccountEntity(
    reference: ReferenceEntity(id: id, path: path),
    uid: data['uid'] as String,
    storeName: data['storeName'] as String,
    email: data['email'] as String,
    displayName: data['displayName'] as String,
    phoneNumber: data['phoneNumber'] as int?,
    photoURL: data['photoURL'] as String?,
    status: AccountStatus.values[data['status'] as int],
    hasPremiumEnabled: data['hasPremiumEnabled'] as bool,
    hasSendRating: data['hasSendRating'] == true,
    rating: data['rating'] as int? ?? 0,
    notice: data['notice'] as String,
    hasReadNotice: data['hasReadNotice'] == true,
  );
}
