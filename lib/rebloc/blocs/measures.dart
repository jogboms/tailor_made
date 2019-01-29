import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class MeasuresBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    // final _measures = state.measures;

    // if (action is MeasuresUpdateAction) {
    //   return state.copyWith(
    //     measures: _measures.copyWith(
    //       measures: action.measures,
    //       status: MeasuresStatus.success,
    //     ),
    //   );
    // }

    return state;
  }
}
