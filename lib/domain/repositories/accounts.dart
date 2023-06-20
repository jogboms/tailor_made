import '../entities.dart';

abstract class Accounts {
  Future<void> signInWithGoogle();

  Stream<String?> get onAuthStateChanged;

  Future<void>? signOut();

  Future<void> signUp(AccountEntity account);

  Future<AccountEntity?> getAccount(String userId);

  Future<bool> updateAccount(
    String userId, {
    required String id,
    required String path,
    String? storeName,
    bool? hasSendRating,
    int? rating,
    bool? hasReadNotice,
  });
}
