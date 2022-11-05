import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

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

  final List<ContactModel>? _contacts;

  List<ContactModel>? get contacts => _contacts;

  final List<JobModel>? _jobs;

  List<JobModel>? get jobs => _jobs;

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
