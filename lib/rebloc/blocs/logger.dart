import 'dart:async' show Future;

import 'package:tailor_made/rebloc/states/main.dart';
import 'package:rebloc/rebloc.dart';

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

    // This is just to demonstrate that middleware can be async. In most cases,
    // you'll want to cancel or return immediately.
    return await Future.delayed(Duration.zero, () => action);
  }
}
