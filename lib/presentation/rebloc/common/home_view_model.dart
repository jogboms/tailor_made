import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class HomeViewModel extends Equatable {
  HomeViewModel(AppState state)
      : account = state.account.account,
        _contacts = state.contacts.contacts ?? <ContactEntity>[],
        _jobs = state.jobs.jobs ?? <JobEntity>[],
        stats = state.stats.stats,
        settings = state.settings.settings,
        hasSkippedPremium = state.account.hasSkipedPremium == true,
        isLoading = state.stats.status == StateStatus.loading ||
            state.contacts.status == StateStatus.loading ||
            state.account.status == StateStatus.loading;

  final AccountEntity? account;

  final List<ContactEntity> _contacts;

  List<ContactEntity> get contacts => _contacts;

  final List<JobEntity> _jobs;

  final StatsModel? stats;
  final SettingEntity? settings;
  final bool isLoading;
  final bool hasSkippedPremium;

  bool get isDisabled => account != null && account!.status == AccountStatus.disabled;

  bool get isWarning => account != null && account!.status == AccountStatus.warning;

  bool get isPending => account != null && account!.status == AccountStatus.pending;

  bool get shouldSendRating =>
      account != null && !account!.hasSendRating && (contacts.length >= 10 || _jobs.length >= 10);

  @override
  List<Object?> get props => <Object?>[stats, settings, hasSkippedPremium, isLoading, account, contacts, _jobs];
}
