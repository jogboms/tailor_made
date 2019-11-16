import 'dart:async' show Future;

import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/app_state.dart';

class LoggerBloc extends SimpleBloc<AppState> {
  LoggerBloc(this.isTesting);

  final bool isTesting;

  @override
  Future<Action> afterware(dispatcher, state, action) async {
    if (!isTesting) {
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
