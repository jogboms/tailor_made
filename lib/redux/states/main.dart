import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/settings.dart';
import 'package:tailor_made/redux/states/stats.dart';

@immutable
class ReduxState {
  final ContactsState contacts;
  final JobsState jobs;
  final StatsState stats;
  final AccountState account;
  final SettingsState settings;

  const ReduxState({
    @required this.contacts,
    @required this.jobs,
    @required this.stats,
    @required this.account,
    @required this.settings,
  });

  const ReduxState.initialState()
      : contacts = const ContactsState.initialState(),
        jobs = const JobsState.initialState(),
        account = const AccountState.initialState(),
        settings = const SettingsState.initialState(),
        stats = const StatsState.initialState();

  ReduxState copyWith({
    ContactsState contacts,
    JobsState jobs,
    StatsState stats,
    AccountState account,
    SettingsState settings,
  }) {
    return new ReduxState(
      contacts: contacts ?? this.contacts,
      jobs: jobs ?? this.jobs,
      stats: stats ?? this.stats,
      account: account ?? this.account,
      settings: settings ?? this.settings,
    );
  }
}
