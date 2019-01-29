import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/blocs/account.dart';
import 'package:tailor_made/rebloc/blocs/auth.dart';
import 'package:tailor_made/rebloc/blocs/contacts.dart';
import 'package:tailor_made/rebloc/blocs/initialize.dart';
import 'package:tailor_made/rebloc/blocs/jobs.dart';
import 'package:tailor_made/rebloc/blocs/logger.dart';
import 'package:tailor_made/rebloc/blocs/measures.dart';
import 'package:tailor_made/rebloc/blocs/settings.dart';
import 'package:tailor_made/rebloc/blocs/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';

Store<AppState> reblocStore() {
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
