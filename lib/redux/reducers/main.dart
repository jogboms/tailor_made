import 'package:tailor_made/redux/reducers/contacts.dart' as contacts;
import 'package:tailor_made/redux/reducers/jobs.dart' as jobs;
import 'package:tailor_made/redux/reducers/stats.dart' as stats;
import 'package:tailor_made/redux/states/main.dart';

ReduxState reduxReducer(ReduxState state, action) => new ReduxState(
      contacts: contacts.reducer(state, action),
      jobs: jobs.reducer(state, action),
      stats: stats.reducer(state, action),
    );
