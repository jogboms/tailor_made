import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:tailor_made/redux/epics/main.dart';
import 'package:tailor_made/redux/reducers/main.dart';
import 'package:tailor_made/redux/states/main.dart';

Store reduxStore() => new Store<ReduxState>(
      reduxReducer,
      initialState: const ReduxState.initialState(),
      middleware: [
        new LoggingMiddleware<dynamic>.printer(),
        reduxEpics(),
      ],
    );
