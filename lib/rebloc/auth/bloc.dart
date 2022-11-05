import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/accounts/actions.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/auth/actions.dart';
import 'package:tailor_made/rebloc/contacts/actions.dart';
import 'package:tailor_made/rebloc/jobs/actions.dart';
import 'package:tailor_made/rebloc/measures/actions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';
import 'package:tailor_made/rebloc/stats/actions.dart';
import 'package:tailor_made/services/accounts/main.dart';

class AuthBloc extends SimpleBloc<AppState> {
  AuthBloc(this.accounts);

  final Accounts accounts;

  @override
  Future<Action> middleware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnLoginAction) {
      dispatcher(InitAccountAction(action.user!.uid));
      dispatcher(InitMeasuresAction(action.user!.uid));
      dispatcher(InitStatsAction(action.user!.uid));
      dispatcher(InitJobsAction(action.user!.uid));
      dispatcher(InitContactsAction(action.user!.uid));
    }
    return action;
  }

  @override
  AppState reducer(AppState state, Action action) {
    if (action is OnLogoutAction) {
      return AppState.initialState();
    }

    return state;
  }

  @override
  Future<Action> afterware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnLogoutAction) {
      await accounts.signout();
      dispatcher(const InitSettingsAction());
    }
    return action;
  }
}
