import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/reducers/account.dart' as account;
import 'package:tailor_made/redux/reducers/contacts.dart' as contacts;
import 'package:tailor_made/redux/reducers/jobs.dart' as jobs;
import 'package:tailor_made/redux/reducers/measures.dart' as measures;
import 'package:tailor_made/redux/reducers/settings.dart' as settings;
import 'package:tailor_made/redux/reducers/stats.dart' as stats;
import 'package:tailor_made/rebloc/states/main.dart';

AppState reduxReducer(AppState state, dynamic action) {
  if (action is OnLogoutEvent) {
    return AppState.initialState();
  }

  return AppState(
    contacts: contacts.reducer(state.contacts, action),
    jobs: jobs.reducer(state.jobs, action),
    stats: stats.reducer(state.stats, action),
    account: account.reducer(state.account, action),
    measures: measures.reducer(state.measures, action),
    settings: settings.reducer(state.settings, action),
  );
}
