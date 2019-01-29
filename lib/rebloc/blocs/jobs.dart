import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class JobsBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    // final _jobs = state.jobs;

    // if (action is JobsUpdateAction) {
    //   return state.copyWith(
    //     jobs: _jobs.copyWith(
    //       jobs: action.jobs,
    //       status: JobsStatus.success,
    //     ),
    //   );
    // }

    return state;
  }
}
