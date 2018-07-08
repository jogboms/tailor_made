import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/jobs.dart';

@immutable
class ReduxState {
  final ContactsState contacts;
  final JobsState jobs;

  const ReduxState({
    this.contacts,
    this.jobs,
  });

  ReduxState copyWith({
    ContactsState contacts,
    JobsState jobs,
  }) {
    return new ReduxState(
      contacts: contacts ?? this.contacts,
      jobs: jobs ?? this.jobs,
    );
  }
}
