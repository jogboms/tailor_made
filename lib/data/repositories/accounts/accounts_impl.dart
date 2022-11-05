import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class AccountsImpl extends Accounts {
  AccountsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Future<void> signInWithGoogle() => repository.auth.signInWithGoogle();

  @override
  Stream<FireUser> get onAuthStateChanged => repository.auth.onAuthStateChanged;

  @override
  Future<void> signOut() => repository.auth.signOutWithGoogle();

  @override
  Future<void> readNotice(AccountModel account) async => account.reference?.updateData(account.toJson());

  @override
  Future<void> sendRating(AccountModel account) async => account.reference?.updateData(account.toJson());

  @override
  Future<void> signUp(AccountModel account) async {
    await account.reference?.updateData(account.toJson());
    await repository.db.premium.doc(account.uid).set(account.toJson());
  }

  @override
  Stream<AccountModel> getAccount(String? userId) {
    return repository.db.account(userId).snapshots().map(_deriveAccountModel);
  }
}

AccountModel _deriveAccountModel(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final Map<String, dynamic> data = snapshot.data()!;
  return AccountModel(
    reference: FireReference(snapshot.reference),
    uid: data['uid'] as String,
    storeName: data['storeName'] as String,
    email: data['email'] as String,
    displayName: data['displayName'] as String,
    phoneNumber: data['phoneNumber'] as int?,
    photoURL: data['photoURL'] as String,
    status: AccountModelStatus.values.byName(data['status'] as String),
    hasPremiumEnabled: data['hasPremiumEnabled'] as bool,
    hasSendRating: data['hasSendRating'] as bool,
    rating: data['rating'] as int,
    notice: data['notice'] as String,
    hasReadNotice: data['hasReadNotice'] as bool,
  );
}
