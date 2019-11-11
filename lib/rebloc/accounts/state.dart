import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/app_state.dart';

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
        status = StateStatus.loading,
        hasSkipedPremium = false,
        message = '',
        error = null;

  final AccountModel account;
  final StateStatus status;
  final bool hasSkipedPremium;
  final String message;
  final dynamic error;

  AccountState copyWith({
    AccountModel account,
    StateStatus status,
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
