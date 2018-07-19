import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/account.dart';

enum AccountStatus {
  loading,
  success,
  failure,
}

@immutable
class AccountState {
  final AccountModel account;
  final AccountStatus status;
  final bool hasSkipedPremium;
  final String message;

  const AccountState({
    @required this.account,
    @required this.status,
    @required this.hasSkipedPremium,
    @required this.message,
  });

  const AccountState.initialState()
      : account = null,
        status = AccountStatus.loading,
        hasSkipedPremium = false,
        message = '';

  AccountState copyWith({
    AccountModel account,
    AccountStatus status,
    bool hasSkipedPremium,
    String message,
  }) {
    return new AccountState(
      account: account ?? this.account,
      status: status ?? this.status,
      hasSkipedPremium: hasSkipedPremium ?? this.hasSkipedPremium,
      message: message ?? this.message,
    );
  }
}
