import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';

class JobsListWidget extends StatelessWidget {
  final ContactModel contact;

  const JobsListWidget({
    Key key,
    @required this.contact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<ReduxState, JobsViewModel>(
      converter: (store) => JobsViewModel(store)..contact = contact,
      builder: (BuildContext context, JobsViewModel vm) {
        if (vm.isLoading) {
          return SliverFillRemaining(
            child: loadingSpinner(),
          );
        }
        return JobList(jobs: vm.jobs);
      },
    );
  }
}
