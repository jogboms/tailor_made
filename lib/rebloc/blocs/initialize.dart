import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class InitializeBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> middleware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    if (action is OnInitAction) {}
    return action;
  }

  @override
  Future<Action> afterware(
    DispatchFunction dispatcher,
    AppState state,
    Action action,
  ) async {
    if (action is OnDisposeAction) {}
    return action;
  }
}
