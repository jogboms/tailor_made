import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/utils/mk_version_check.dart';
import 'package:version/version.dart';

class HomeViewModel extends Equatable {
  HomeViewModel(AppState state)
      : account = state.account.account,
        _contacts = state.contacts.contacts,
        _jobs = state.jobs.jobs,
        stats = state.stats.stats,
        settings = state.settings.settings,
        hasSkipedPremium = state.account.hasSkipedPremium == true,
        isLoading = state.stats.status == StateStatus.loading ||
            state.contacts.status == StateStatus.loading ||
            state.account.status == StateStatus.loading;

  final AccountModel account;

  final BuiltList _contacts;

  List<ContactModel> get contacts => _contacts?.toList();

  final BuiltList _jobs;

  List<JobModel> get jobs => _jobs?.toList();

  final StatsModel stats;
  final SettingsModel settings;
  final bool isLoading;
  final bool hasSkipedPremium;

  bool get isDisabled => account != null && account.status == AccountModelStatus.disabled;

  bool get isWarning => account != null && account.status == AccountModelStatus.warning;

  bool get isPending => account != null && account.status == AccountModelStatus.pending;

  bool get shouldSendRating =>
      account != null && !account.hasSendRating && (((contacts?.length ?? 0) >= 10) || ((jobs?.length ?? 0) >= 10));

  bool get isOutdated {
    final currentVersion = Version.parse(MkVersionCheck.get());
    final latestVersion = Version.parse(settings?.versionName ?? "1.0.0");

    return latestVersion > currentVersion;
  }

  @override
  List<Object> get props => [stats, settings, hasSkipedPremium, isLoading, account, contacts, jobs];
}
