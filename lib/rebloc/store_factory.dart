import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/rebloc/accounts/bloc.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/auth/bloc.dart';
import 'package:tailor_made/rebloc/common/initialize.dart';
import 'package:tailor_made/rebloc/common/logger.dart';
import 'package:tailor_made/rebloc/contacts/bloc.dart';
import 'package:tailor_made/rebloc/jobs/bloc.dart';
import 'package:tailor_made/rebloc/measures/bloc.dart';
import 'package:tailor_made/rebloc/settings/bloc.dart';
import 'package:tailor_made/rebloc/stats/bloc.dart';

Store<AppState> storeFactory(Dependencies dependencies, bool isTesting) {
  return Store<AppState>(
    initialState: AppState.initialState(),
    blocs: [
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
