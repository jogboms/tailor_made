import 'package:redux_epics/redux_epics.dart';
import 'package:tailor_made/redux/epics/account.dart' as account;
import 'package:tailor_made/redux/epics/contacts.dart' as contacts;
import 'package:tailor_made/redux/epics/jobs.dart' as jobs;
import 'package:tailor_made/redux/epics/settings.dart' as settings;
import 'package:tailor_made/redux/epics/stats.dart' as stats;
import 'package:tailor_made/redux/states/main.dart';

EpicMiddleware<ReduxState> reduxEpics() => new EpicMiddleware<ReduxState>(
      combineEpics<ReduxState>(
        [
          contacts.contacts,
          contacts.search,
          jobs.jobs,
          jobs.search,
          stats.stats,
          settings.settings,
          account.account,
          account.onPremiumSignUp,
          account.onReadNotice,
        ],
      ),
    );
