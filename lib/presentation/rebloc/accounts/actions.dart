part of 'bloc.dart';

@freezed
class AccountAction with _$AccountAction, AppAction {
  const factory AccountAction.readNotice(AccountEntity payload) = _OnReadNotice;
  const factory AccountAction.sendRating(AccountEntity account, int rating) = _OnSendRating;
}
