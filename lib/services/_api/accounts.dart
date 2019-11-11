import 'package:firebase_auth/firebase_auth.dart';
import 'package:tailor_made/firebase/auth.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/services/accounts.dart';
import 'package:tailor_made/utils/mk_settings.dart';

class AccountsImpl extends Accounts {
  @override
  FirebaseUser get getUser => Auth.getUser;

  @override
  Future<FirebaseUser> signInWithGoogle() => Auth.signInWithGoogle();

  @override
  Future<FirebaseUser> get onAuthStateChanged => Auth.onAuthStateChanged
      .firstWhere((user) => user != null)
      .then((user) => Auth.setUser(user));

  @override
  Future<Null> signout() => Auth.signOutWithGoogle();

  @override
  Future<void> readNotice(AccountModel account) async {
    try {
      await account.reference.updateData(
        account.copyWith(hasReadNotice: true).toMap(),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> sendRating(
    AccountModel account,
    int rating,
  ) async {
    try {
      await account.reference.updateData(
        account.copyWith(hasSendRating: true, rating: rating).toMap(),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Future<void> signUp(AccountModel account) async {
    try {
      final _account = account.copyWith(
        status: AccountModelStatus.pending,
        notice: MkSettings.getData().premiumNotice,
        hasReadNotice: false,
        hasPremiumEnabled: true,
      );
      await account.reference.updateData(_account.toMap());
      await CloudDb.premium.document(account.uid).setData(_account.toMap());
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  @override
  Stream<AccountModel> getAccount() {
    return CloudDb.account
        .snapshots()
        .map((snapshot) => AccountModel.fromDoc(Snapshot.fromFire(snapshot)));
  }
}
