import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';

class AuthBloc extends SimpleBloc<AppState> {
  AuthBloc(this.accounts);

  final Accounts accounts;

  @override
  Future<Action> middleware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is _OnLoginAction) {
      dispatcher(AccountAction.init(action.user));
      dispatcher(InitMeasuresAction(action.user));
      dispatcher(InitStatsAction(action.user));
      dispatcher(InitJobsAction(action.user));
      dispatcher(ContactsAction.init(action.user));
    }
    return action;
  }

  @override
  AppState reducer(AppState state, Action action) {
    if (action is _OnLogoutAction) {
      return AppState.initialState;
    }

    return state;
  }

  @override
  Future<Action> afterware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is _OnLogoutAction) {
      await accounts.signOut();
      dispatcher(const SettingsAction.init());
    }
    return action;
  }
}
