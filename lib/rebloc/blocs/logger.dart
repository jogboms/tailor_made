import 'dart:async' show Future;

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/states/main.dart';

/// Logs each incoming action.
class LoggerBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> afterware(
      DispatchFunction dispatcher, AppState state, Action action) async {
    // if (state != lastState) {
    //   print('State just became: $state');
    //   lastState = state;
    // }
    print("{\n$state\n}");
    return action;
  }

  @override
  Future<Action> middleware(dispatcher, state, action) async {
    print("[ReBLoC]: ${action.runtimeType}");

    return action;
  }
}
