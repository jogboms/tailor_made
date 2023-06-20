part of 'bloc.dart';

@freezed
class AccountAction with _$AccountAction, AppAction {
  const factory AccountAction.init(String userId) = _InitAccountAction;
  const factory AccountAction.premiumSignUp(AccountEntity payload) = _OnPremiumSignUp;
  const factory AccountAction.readNotice(AccountEntity payload) = _OnReadNotice;
  const factory AccountAction.sendRating(AccountEntity account, int rating) = _OnSendRating;
  const factory AccountAction.skippedPremium() = _OnSkipedPremium;
}