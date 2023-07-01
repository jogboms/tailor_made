import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'home_notifier_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account, contacts, jobs, settings, stats])
class HomeNotifier extends _$HomeNotifier {
  @override
  Stream<HomeState> build() async* {
    final AccountEntity account = await ref.watch(accountProvider.future);
    final List<ContactEntity> contacts = await ref.watch(contactsProvider.future);
    final List<JobEntity> jobs = await ref.watch(jobsProvider.future);
    final SettingEntity settings = await ref.watch(settingsProvider.future);
    final StatsEntity stats = await ref.watch(statsProvider.future);

    yield HomeState(
      account: account,
      contacts: contacts,
      jobs: jobs,
      isLoading: false,
      stats: stats,
      settings: settings,
      hasSkippedPremium: false,
    );
  }

  void premiumSetup() async {
    final HomeState homeState = state.requireValue;
    await ref.read(registryProvider).get<Accounts>().signUp(
          homeState.account.copyWith(
            status: AccountStatus.pending,
            notice: homeState.settings.premiumNotice,
            hasReadNotice: false,
            hasPremiumEnabled: true,
          ),
        );
    ref.invalidate(accountProvider);
    ref.invalidateSelf();
  }

  void skippedPremium() {
    state = AsyncValue<HomeState>.data(
      state.requireValue.copyWith(
        hasSkippedPremium: true,
      ),
    );
  }

  void logout() async {
    await ref.read(registryProvider).get<Accounts>().signOut();
    ref.invalidate(accountProvider);
  }
}

class HomeState {
  const HomeState({
    required this.account,
    required this.contacts,
    required this.jobs,
    required this.stats,
    required this.settings,
    required this.isLoading,
    required this.hasSkippedPremium,
  });

  final AccountEntity account;
  final List<ContactEntity> contacts;
  final List<JobEntity> jobs;
  final StatsEntity stats;
  final SettingEntity settings;
  final bool isLoading;
  final bool hasSkippedPremium;

  bool get isDisabled => account.status == AccountStatus.disabled;

  bool get isWarning => account.status == AccountStatus.warning;

  bool get isPending => account.status == AccountStatus.pending;

  bool get shouldSendRating => !account.hasSendRating && (contacts.length >= 10 || jobs.length >= 10);

  HomeState copyWith({
    AccountEntity? account,
    List<ContactEntity>? contacts,
    List<JobEntity>? jobs,
    StatsEntity? stats,
    SettingEntity? settings,
    bool? isLoading,
    bool? hasSkippedPremium,
  }) {
    return HomeState(
      account: account ?? this.account,
      contacts: contacts ?? this.contacts,
      jobs: jobs ?? this.jobs,
      stats: stats ?? this.stats,
      settings: settings ?? this.settings,
      isLoading: isLoading ?? this.isLoading,
      hasSkippedPremium: hasSkippedPremium ?? this.hasSkippedPremium,
    );
  }
}
