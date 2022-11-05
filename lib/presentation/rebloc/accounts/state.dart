part of 'bloc.dart';

@freezed
class AccountState with _$AccountState {
  const factory AccountState({
    required AccountModel? account,
    required StateStatus status,
    required bool hasSkipedPremium,
    required String? error,
  }) = _AccountState;
}
