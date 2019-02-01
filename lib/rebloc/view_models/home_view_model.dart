import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/rebloc/states/account.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';
import 'package:tailor_made/rebloc/view_models/stats.dart';
import 'package:tailor_made/services/settings.dart';
import 'package:version/version.dart';

class HomeViewModel extends StatsViewModel {
  HomeViewModel(AppState state)
      : account = state.account.account,
        contacts = state.contacts.contacts,
        jobs = state.jobs.jobs,
        stats = state.stats.stats,
        settings = state.settings.settings,
        hasSkipedPremium = state.account.hasSkipedPremium == true,
        _isLoading = state.stats.status == StatsStatus.loading ||
            state.contacts.status == ContactsStatus.loading ||
            state.account.status == AccountStatus.loading,
        super(state);

  final AccountModel account;
  final List<ContactModel> contacts;
  final List<JobModel> jobs;
  final StatsModel stats;
  final SettingsModel settings;
  final bool _isLoading;
  @override
  bool get isLoading => _isLoading;
  final bool hasSkipedPremium;
  bool get isDisabled => account.status == AccountModelStatus.disabled;
  bool get isWarning => account.status == AccountModelStatus.warning;
  bool get isPending => account.status == AccountModelStatus.pending;

  bool get shouldSendRating {
    return !account.hasSendRating &&
        (((contacts?.length ?? 0) >= 10) || ((jobs?.length ?? 0) >= 10));
  }

  bool get isOutdated {
    final currentVersion = Version.parse(Settings.getVersion());
    final latestVersion = Version.parse(settings?.versionName ?? "1.0.0");

    return latestVersion > currentVersion;
  }
}
