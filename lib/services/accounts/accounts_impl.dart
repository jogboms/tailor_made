import 'package:tailor_made/firebase/auth.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/services/accounts/accounts.dart';
import 'package:tailor_made/services/session.dart';

class AccountsImpl extends Accounts {
  @override
  User get getUser => Auth.getUser;

  @override
  Future<User> signInWithGoogle() => Auth.signInWithGoogle();

  @override
  Future<User> get onAuthStateChanged =>
      Auth.onAuthStateChanged.firstWhere((user) => user != null).then((user) => Auth.setUser(user));

  @override
  Future<Null> signout() => Auth.signOutWithGoogle();

  @override
  Future<void> readNotice(AccountModel account) async {
    await account.reference.updateData(account.rebuild((b) => b..hasReadNotice = true).toMap());
  }

  @override
  Future<void> sendRating(AccountModel account, int rating) async {
    await account.reference.updateData(account
        .rebuild((b) => b
          ..hasSendRating = true
          ..rating = rating)
        .toMap());
  }

  @override
  Future<void> signUp(AccountModel account) async {
    final _account = account.rebuild((b) => b
      ..status = AccountModelStatus.pending
      ..notice = Session.di().getSettings().premiumNotice
      ..hasReadNotice = false
      ..hasPremiumEnabled = true);
    await account.reference.updateData(_account.toMap());
    await CloudDb.premium.document(account.uid).setData(_account.toMap());
  }

  @override
  Stream<AccountModel> getAccount() {
    return CloudDb.account.snapshots().map((snapshot) => AccountModel.fromSnapshot(Snapshot(snapshot)));
  }
}
