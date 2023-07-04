import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'home_notifier_provider.g.dart';

@Riverpod(dependencies: <Object>[account, contacts, jobs, settings, stats])
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
      stats: stats,
      settings: settings,
      shouldSendRating: !account.hasSendRating && (contacts.length >= 10 || jobs.length >= 10),
      hasSkippedPremium: false,
    );
  }

  void skippedPremium() {
    state = AsyncValue<HomeState>.data(
      state.requireValue.copyWith(
        hasSkippedPremium: true,
      ),
    );
  }
}

class HomeState with EquatableMixin {
  const HomeState({
    required this.account,
    required this.stats,
    required this.settings,
    required this.shouldSendRating,
    required this.hasSkippedPremium,
  });

  final AccountEntity account;
  final StatsEntity stats;
  final SettingEntity settings;
  final bool shouldSendRating;
  final bool hasSkippedPremium;

  bool get isDisabled => account.status == AccountStatus.disabled;

  bool get isWarning => account.status == AccountStatus.warning;

  bool get isPending => account.status == AccountStatus.pending;

  @override
  List<Object> get props => <Object>[account, stats, settings, shouldSendRating, hasSkippedPremium];

  HomeState copyWith({
    bool? hasSkippedPremium,
  }) {
    return HomeState(
      account: account,
      stats: stats,
      settings: settings,
      shouldSendRating: shouldSendRating,
      hasSkippedPremium: hasSkippedPremium ?? this.hasSkippedPremium,
    );
  }
}
