import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'bloc.freezed.dart';
part 'state.dart';

class StatsBloc extends SimpleBloc<AppState> {
  StatsBloc(this.stats);

  final Stats stats;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    return state;
  }
}
