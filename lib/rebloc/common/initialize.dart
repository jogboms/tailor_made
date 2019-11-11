import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/settings/actions.dart';

class InitializeBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnInitAction) {
      dispatcher(const InitSettingsAction());
    }
    return action;
  }

  @override
  Future<Action> afterware(DispatchFunction dispatcher, AppState state, Action action) async {
    if (action is OnDisposeAction) {}
    return action;
  }
}
