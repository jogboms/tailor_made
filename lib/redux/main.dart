import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:tailor_made/redux/epics/main.dart';
import 'package:tailor_made/redux/reducers/main.dart';
import 'package:tailor_made/rebloc/states/main.dart';

Store reduxStore() => Store<AppState>(
      reduxReducer,
      initialState: const AppState.initialState(),
      middleware: [
        LoggingMiddleware<dynamic>.printer(),
        reduxEpics(),
      ],
    );
