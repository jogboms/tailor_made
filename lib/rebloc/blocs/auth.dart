import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/account.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/actions/jobs.dart';
import 'package:tailor_made/rebloc/actions/measures.dart';
import 'package:tailor_made/rebloc/actions/settings.dart';
import 'package:tailor_made/rebloc/actions/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class AuthBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    if (action is OnLoginAction) {
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
      // TODO: critical
      return AppState.initialState();
      // return state.copyWith(
      //   // contacts: const ContactsState.initialState(),
      //   // jobs: const JobsState.initialState(),
      //   // account: const AccountState.initialState(),
      //   measures: const MeasuresState.initialState(),
      //   // settings: const SettingsState.initialState(),
      //   // stats: const StatsState.initialState(),
      // );
    }

    return state;
  }

  @override
  Future<Action> afterware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    if (action is OnLogoutAction) {
      dispatcher(const InitSettingsAction());
    }
    return action;
  }
}
