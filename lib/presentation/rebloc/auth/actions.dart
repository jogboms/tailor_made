part of 'bloc.dart';

@freezed
class AuthAction with _$AuthAction, AppAction {
  const factory AuthAction.login(User? user) = OnLoginAction;
  const factory AuthAction.logout() = OnLogoutAction;
}
