import 'package:redux_epics/redux_epics.dart';
import 'package:tailor_made/redux/epics/account.dart' as account;
import 'package:tailor_made/redux/epics/contacts.dart' as contacts;
import 'package:tailor_made/redux/epics/jobs.dart' as jobs;
import 'package:tailor_made/redux/epics/measures.dart' as measures;
import 'package:tailor_made/redux/epics/settings.dart' as settings;
import 'package:tailor_made/redux/epics/stats.dart' as stats;
import 'package:tailor_made/rebloc/states/main.dart';

EpicMiddleware<AppState> reduxEpics() => EpicMiddleware<AppState>(
      combineEpics<AppState>(
        [
          contacts.contacts,
          contacts.search,
          jobs.jobs,
          jobs.search,
          stats.stats,
          measures.init,
          measures.measures,
          settings.settings,
          account.account,
          account.onSendRating,
          account.onPremiumSignUp,
          account.onReadNotice,
        ],
      ),
    );
