import 'package:redux_epics/redux_epics.dart';
import 'package:tailor_made/redux/epics/contacts.dart';
import 'package:tailor_made/redux/epics/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';

EpicMiddleware<ReduxState> reduxEpics() => new EpicMiddleware<ReduxState>(
      combineEpics<ReduxState>(
        [
          contacts,
          jobs,
        ],
      ),
    );
