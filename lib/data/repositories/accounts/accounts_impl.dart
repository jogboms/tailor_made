import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class AccountsImpl extends Accounts {
  AccountsImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Future<void> signInWithGoogle() => firebase.auth.signInWithGoogle();

  @override
  Stream<FireUser?> get onAuthStateChanged => firebase.auth.onAuthStateChanged;

  @override
  Future<void> signOut() => firebase.auth.signOutWithGoogle();

  @override
  Future<void> readNotice(AccountModel account) async => account.reference?.updateData(account.toJson());

  @override
  Future<void> sendRating(AccountModel account) async => account.reference?.updateData(account.toJson());

  @override
  Future<void> signUp(AccountModel account) async {
    await account.reference?.updateData(account.toJson());
    await firebase.db.premium.doc(account.uid).set(account.toJson());
  }

  @override
  Stream<AccountModel> getAccount(String? userId) => firebase.db.account(userId).snapshots().map(_deriveAccountModel);
}

AccountModel _deriveAccountModel(MapDocumentSnapshot snapshot) {
  final DynamicMap data = snapshot.data()!;
  return AccountModel(
    reference: FireReference(snapshot.reference),
    uid: data['uid'] as String,
    storeName: data['storeName'] as String,
    email: data['email'] as String,
    displayName: data['displayName'] as String,
    phoneNumber: data['phoneNumber'] as int?,
    photoURL: data['photoURL'] as String,
    status: AccountModelStatus.values[data['status'] as int],
    hasPremiumEnabled: data['hasPremiumEnabled'] as bool,
    hasSendRating: data['hasSendRating'] as bool,
    rating: data['rating'] as int,
    notice: data['notice'] as String,
    hasReadNotice: data['hasReadNotice'] as bool,
  );
}
