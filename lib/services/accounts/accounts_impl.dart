import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/accounts/accounts.dart';
import 'package:tailor_made/dependencies.dart';

class AccountsImpl extends Accounts<FirebaseRepository> {
  @override
  Future<FireUser> signInWithGoogle() => repository.auth.signInWithGoogle();

  @override
  Future<FireUser> get onAuthStateChanged => repository.auth.onAuthStateChanged.firstWhere((user) => user != null);

  @override
  Future<void> signout() => repository.auth.signOutWithGoogle();

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
      ..notice = Dependencies.di().session.getSettings().premiumNotice
      ..hasReadNotice = false
      ..hasPremiumEnabled = true);
    await account.reference.updateData(_account.toMap());
    await repository.db.premium.document(account.uid).setData(_account.toMap());
  }

  @override
  Stream<AccountModel> getAccount() {
    return repository.db
        .account(Dependencies.di().session.getUserId())
        .snapshots()
        .map((snapshot) => AccountModel.fromSnapshot(FireSnapshot(snapshot)));
  }
}
