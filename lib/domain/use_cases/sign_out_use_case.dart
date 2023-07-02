import 'dart:async';

import '../repositories/accounts.dart';

class SignOutUseCase {
  const SignOutUseCase({required Accounts accounts}) : _accounts = accounts;

  final Accounts _accounts;

  Future<void> call() async {
    final Completer<void> completer = Completer<void>();

    late StreamSubscription<void> sub;
    sub = _accounts.onAuthStateChanged.where((String? id) => id == null).listen(
      (_) {
        completer.complete();
        sub.cancel();
      },
      onError: (Object error, StackTrace st) {
        completer.completeError(error, st);
        sub.cancel();
      },
    );

    await _accounts.signOut();

    return completer.future;
  }
}
