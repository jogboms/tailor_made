part of 'bloc.dart';

@freezed
class AuthAction with _$AuthAction, AppAction {
  const factory AuthAction.login(User user) = _OnLoginAction;
  const factory AuthAction.logout() = _OnLogoutAction;
}
