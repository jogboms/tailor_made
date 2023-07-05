import 'dart:async';

import 'package:rxdart/transformers.dart';
import 'package:tailor_made/core.dart';

import '../entities/account_entity.dart';
import '../entities/auth_exception.dart';
import '../repositories/accounts.dart';

class SignInUseCase {
  const SignInUseCase({required Accounts accounts}) : _accounts = accounts;

  final Accounts _accounts;

  Future<AccountEntity> call() async {
    final Completer<AccountEntity> completer = Completer<AccountEntity>();

    late StreamSubscription<void> sub;
    sub = _accounts.onAuthStateChanged.whereType<String>().listen(
      (_) {
        completer.complete(_accounts.fetch());
        sub.cancel();
      },
      onError: (Object error, StackTrace stackTrace) {
        completer.completeError(error, stackTrace);
        sub.cancel();
      },
    );

    try {
      await _accounts.signIn();
    } on AuthException catch (error, stackTrace) {
      if (error is AuthExceptionFailed) {
        AppLog.e(error, stackTrace);
      }
      rethrow;
    }

    return completer.future;
  }
}
