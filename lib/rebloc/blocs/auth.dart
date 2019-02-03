import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/measures.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class AuthBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    if (action is OnLoginAction) {
      // dispatcher(const OnInitAction());
      dispatcher(const OnInitMeasuresAction());
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
}
