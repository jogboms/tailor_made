import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:tailor_made/redux/epics/main.dart';
import 'package:tailor_made/redux/reducers/main.dart';
import 'package:tailor_made/redux/states/contacts.dart' as contacts;
import 'package:tailor_made/redux/states/jobs.dart' as jobs;
import 'package:tailor_made/redux/states/main.dart';

ReduxState initialState = new ReduxState(
  contacts: contacts.initialState,
  jobs: jobs.initialState,
);

Store reduxStore() => new Store<ReduxState>(
      reduxReducer,
      initialState: initialState,
      middleware: [
        new LoggingMiddleware.printer(),
        reduxEpics(),
      ],
    );
