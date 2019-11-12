import 'package:rebloc/rebloc.dart';
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

Store<AppState> storeFactory() {
  return Store<AppState>(
    initialState: AppState.initialState(),
    blocs: [
      InitializeBloc(),
      AuthBloc(),
      AccountBloc(),
      ContactsBloc(),
      MeasuresBloc(),
      SettingsBloc(),
      StatsBloc(),
      JobsBloc(),
      LoggerBloc(),
    ],
  );
}
