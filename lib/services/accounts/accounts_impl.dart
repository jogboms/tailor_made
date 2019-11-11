import 'package:firebase_auth/firebase_auth.dart';
import 'package:tailor_made/firebase/auth.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/services/accounts/accounts.dart';
import 'package:tailor_made/utils/mk_settings.dart';

class AccountsImpl extends Accounts {
  @override
  FirebaseUser get getUser => Auth.getUser;

  @override
  Future<FirebaseUser> signInWithGoogle() => Auth.signInWithGoogle();

  @override
  Future<FirebaseUser> get onAuthStateChanged =>
      Auth.onAuthStateChanged.firstWhere((user) => user != null).then((user) => Auth.setUser(user));

  @override
  Future<Null> signout() => Auth.signOutWithGoogle();

  @override
  Future<void> readNotice(AccountModel account) async {
    await account.reference.updateData(account.copyWith(hasReadNotice: true).toMap());
  }

  @override
  Future<void> sendRating(AccountModel account, int rating) async {
    await account.reference.updateData(account.copyWith(hasSendRating: true, rating: rating).toMap());
  }

  @override
  Future<void> signUp(AccountModel account) async {
    final _account = account.copyWith(
      status: AccountModelStatus.pending,
      notice: MkSettings.getData().premiumNotice,
      hasReadNotice: false,
      hasPremiumEnabled: true,
    );
    await account.reference.updateData(_account.toMap());
    await CloudDb.premium.document(account.uid).setData(_account.toMap());
  }

  @override
  Stream<AccountModel> getAccount() {
    return CloudDb.account.snapshots().map((snapshot) => AccountModel.fromDoc(Snapshot.fromDocumentSnapshot(snapshot)));
  }
}
