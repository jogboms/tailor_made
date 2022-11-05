import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/rebloc/app_state.dart';

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

  final AccountModel? account;

  final BuiltList<ContactModel>? _contacts;

  List<ContactModel>? get contacts => _contacts?.toList();

  final BuiltList<JobModel>? _jobs;

  List<JobModel>? get jobs => _jobs?.toList();

  final StatsModel? stats;
  final SettingsModel? settings;
  final bool isLoading;
  final bool hasSkipedPremium;

  bool get isDisabled => account != null && account!.status == AccountModelStatus.disabled;

  bool get isWarning => account != null && account!.status == AccountModelStatus.warning;

  bool get isPending => account != null && account!.status == AccountModelStatus.pending;

  bool get shouldSendRating =>
      account != null && !account!.hasSendRating && (((contacts?.length ?? 0) >= 10) || ((jobs?.length ?? 0) >= 10));

  @override
  List<Object?> get props => <Object?>[stats, settings, hasSkipedPremium, isLoading, account, contacts, jobs];
}
