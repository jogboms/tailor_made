import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/rebloc/accounts/state.dart';
import 'package:tailor_made/rebloc/contacts/state.dart';
import 'package:tailor_made/rebloc/jobs/state.dart';
import 'package:tailor_made/rebloc/measures/state.dart';
import 'package:tailor_made/rebloc/settings/state.dart';
import 'package:tailor_made/rebloc/stats/state.dart';

enum StateStatus { loading, success, failure }

@immutable
class AppState {
  const AppState({
    @required this.contacts,
    @required this.jobs,
    @required this.stats,
    @required this.account,
    @required this.measures,
    @required this.settings,
  });

  const AppState.initialState()
      : contacts = const ContactsState.initialState(),
        jobs = const JobsState.initialState(),
        account = const AccountState.initialState(),
        measures = const MeasuresState.initialState(),
        settings = const SettingsState.initialState(),
        stats = const StatsState.initialState();

  final ContactsState contacts;
  final JobsState jobs;
  final StatsState stats;
  final AccountState account;
  final MeasuresState measures;
  final SettingsState settings;

  AppState copyWith({
    ContactsState contacts,
    JobsState jobs,
    StatsState stats,
    AccountState account,
    MeasuresState measures,
    SettingsState settings,
  }) {
    return AppState(
      contacts: contacts ?? this.contacts,
      jobs: jobs ?? this.jobs,
      stats: stats ?? this.stats,
      account: account ?? this.account,
      measures: measures ?? this.measures,
      settings: settings ?? this.settings,
    );
  }

  @override
  String toString() => """
$contacts
$jobs
$stats
$measures
$settings
$account
		""";
}
