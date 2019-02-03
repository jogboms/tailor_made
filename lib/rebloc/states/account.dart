import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/account.dart';

enum AccountStatus {
  loading,
  success,
  failure,
}

@immutable
class AccountState {
  const AccountState({
    @required this.account,
    @required this.status,
    @required this.hasSkipedPremium,
    @required this.message,
    this.error,
  });

  const AccountState.initialState()
      : account = null,
        status = AccountStatus.loading,
        hasSkipedPremium = false,
        message = '',
        error = null;

  final AccountModel account;
  final AccountStatus status;
  final bool hasSkipedPremium;
  final String message;
  final dynamic error;

  AccountState copyWith({
    AccountModel account,
    AccountStatus status,
    bool hasSkipedPremium,
    String message,
    dynamic error,
  }) {
    return AccountState(
      account: account ?? this.account,
      status: status ?? this.status,
      hasSkipedPremium: hasSkipedPremium ?? this.hasSkipedPremium,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """
Account: ${account?.toMap()},
HasSkipedPremium: $hasSkipedPremium
    """;
}
