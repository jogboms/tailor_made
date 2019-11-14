import 'dart:async' show Future;

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/services/session.dart';

class LoggerBloc extends SimpleBloc<AppState> {
  @override
  Future<Action> afterware(dispatcher, state, action) async {
    if (!Session.di().isTesting) {
      print(state);
    }
    return action;
  }

  @override
  Future<Action> middleware(dispatcher, state, action) async {
    print("[ReBLoC]: ${action.runtimeType}");

    return action;
  }
}
