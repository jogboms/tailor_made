import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/dependencies.dart';

import 'accounts/bloc.dart';
import 'app_state.dart';
import 'auth/bloc.dart';
import 'common/initialize.dart';
import 'common/logger.dart';
import 'contacts/bloc.dart';
import 'jobs/bloc.dart';
import 'measures/bloc.dart';
import 'settings/bloc.dart';
import 'stats/bloc.dart';

Store<AppState> storeFactory(Dependencies dependencies, bool isTesting) {
  return Store<AppState>(
    initialState: AppState.initialState,
    blocs: <Bloc<AppState>>[
      InitializeBloc(),
      AuthBloc(dependencies.accounts),
      AccountBloc(dependencies.accounts),
      ContactsBloc(dependencies.contacts),
      MeasuresBloc(dependencies.measures),
      SettingsBloc(dependencies.settings),
      StatsBloc(dependencies.stats),
      JobsBloc(dependencies.jobs),
      LoggerBloc(isTesting),
    ],
  );
}
