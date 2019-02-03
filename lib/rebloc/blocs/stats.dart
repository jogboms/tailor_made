import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';
import 'package:tailor_made/services/cloud_db.dart';

class StatsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    return input.where((_) => _.action is OnLoginAction).asyncExpand(
          (context) => CloudDb.stats
              .snapshots()
              .map((snapshot) => StatsModel.fromJson(snapshot.data))
              .map((stats) => OnDataStatAction(payload: stats))
              .map((action) => context.copyWith(action))
              .takeWhile((_) => _.action is! OnDisposeAction),
        );
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _stats = state.stats;

    if (action is OnDataStatAction) {
      return state.copyWith(
        stats: _stats.copyWith(
          stats: action.payload,
          status: StatsStatus.success,
        ),
      );
    }

    return state;
  }
}
