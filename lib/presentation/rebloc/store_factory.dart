import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
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

Store<AppState> storeFactory(Dependencies dependencies) {
  return Store<AppState>(
    initialState: AppState.initialState,
    blocs: <Bloc<AppState>>[
      InitializeBloc(),
      AuthBloc(dependencies.get()),
      AccountBloc(dependencies.get()),
      ContactsBloc(dependencies.get()),
      MeasuresBloc(dependencies.get()),
      SettingsBloc(dependencies.get()),
      StatsBloc(dependencies.get()),
      JobsBloc(dependencies.get()),
      LoggerBloc(dependencies.get<Environment>().isTesting),
    ],
  );
}
