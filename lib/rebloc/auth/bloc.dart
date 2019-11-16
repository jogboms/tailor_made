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
import 'package:tailor_made/widgets/dependencies.dart';

class AuthBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnLoginAction) {
      Dependencies.di().session.setUserId(action.user.uid);
      dispatcher(const InitAccountAction());
      dispatcher(const InitMeasuresAction());
      dispatcher(const InitStatsAction());
      dispatcher(const InitJobsAction());
      dispatcher(const InitContactsAction());
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
      dispatcher(const InitSettingsAction());
    }
    return action;
  }
}
