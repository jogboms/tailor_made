part of 'bloc.dart';

@freezed
class AuthAction with _$AuthAction, AppAction {
  const factory AuthAction.login(String user) = _OnLoginAction;
}
