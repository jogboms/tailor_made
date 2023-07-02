part of 'bloc.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    required AccountEntity? account,
    required bool hasSkipedPremium,
    required String? error,
  }) = _AccountState;
}
