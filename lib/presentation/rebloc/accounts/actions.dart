part of 'bloc.dart';

@freezed
class AccountAction with _$AccountAction, AppAction {
  const factory AccountAction.init(String? userId) = InitAccountAction;
  const factory AccountAction.premiumSignUp(AccountModel? payload) = OnPremiumSignUp;
  const factory AccountAction.readNotice(AccountModel? payload) = OnReadNotice;
  const factory AccountAction.sendRating(AccountModel? account, int rating) = OnSendRating;
  const factory AccountAction.skippedPremium() = OnSkipedPremium;
}
