import 'package:rebloc/rebloc.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';

import 'accounts/bloc.dart';
import 'app_state.dart';
import 'auth/bloc.dart';
import 'common/initialize.dart';
import 'common/logger.dart';
import 'measures/bloc.dart';
import 'settings/bloc.dart';
import 'stats/bloc.dart';

Store<AppState> storeFactory(Registry registry) {
  return Store<AppState>(
    initialState: AppState.initialState,
    blocs: <Bloc<AppState>>[
      InitializeBloc(),
      AuthBloc(registry.get()),
      AccountBloc(registry.get()),
      MeasuresBloc(registry.get()),
      SettingsBloc(registry.get()),
      StatsBloc(registry.get()),
      LoggerBloc(registry.get<Environment>().isTesting),
    ],
  );
}
