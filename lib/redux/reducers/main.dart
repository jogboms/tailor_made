import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/reducers/account.dart' as account;
import 'package:tailor_made/redux/reducers/contacts.dart' as contacts;
import 'package:tailor_made/redux/reducers/jobs.dart' as jobs;
import 'package:tailor_made/redux/reducers/settings.dart' as settings;
import 'package:tailor_made/redux/reducers/stats.dart' as stats;
import 'package:tailor_made/redux/states/main.dart';

ReduxState reduxReducer(ReduxState state, dynamic action) {
  if (action is OnLogoutEvent) {
    return ReduxState.initialState();
  }

  return new ReduxState(
    contacts: contacts.reducer(state.contacts, action),
    jobs: jobs.reducer(state.jobs, action),
    stats: stats.reducer(state.stats, action),
    account: account.reducer(state.account, action),
    settings: settings.reducer(state.settings, action),
  );
}
