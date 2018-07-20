import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:tailor_made/redux/epics/main.dart';
import 'package:tailor_made/redux/reducers/main.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';

Store reduxStore() => new Store<ReduxState>(
      reduxReducer,
      initialState: new ReduxState(
        contacts: ContactsState.initialState(),
        jobs: JobsState.initialState(),
        stats: StatsState.initialState(),
        account: AccountState.initialState(),
      ),
      middleware: [
        new LoggingMiddleware<dynamic>.printer(),
        reduxEpics(),
      ],
    );
