import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/stats.dart';

@immutable
class ReduxState {
  final ContactsState contacts;
  final JobsState jobs;
  final StatsState stats;

  const ReduxState({
    this.contacts,
    this.jobs,
    this.stats,
  });

  ReduxState copyWith({
    ContactsState contacts,
    JobsState jobs,
    StatsState stats,
  }) {
    return new ReduxState(
      contacts: contacts ?? this.contacts,
      jobs: jobs ?? this.jobs,
      stats: stats ?? this.stats,
    );
  }
}
