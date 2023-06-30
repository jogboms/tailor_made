import 'dart:async';

import 'package:rebloc/rebloc.dart';

import '../app_state.dart';
import '../settings/bloc.dart';
import 'actions.dart';

class InitializeBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnInitAction) {
      dispatcher(const SettingsAction.init());
    }
    return action;
  }

  @override
  Future<Action> afterware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnDisposeAction) {}
    return action;
  }
}
