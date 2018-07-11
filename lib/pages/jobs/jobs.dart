import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new StoreConnector<ReduxState, JobsViewModel>(
      converter: (store) => JobsViewModel(store),
      onInit: (store) => store.dispatch(new InitDataEvents()),
      onDispose: (store) => store.dispatch(new DisposeDataEvents()),
      builder: (BuildContext context, JobsViewModel vm) {
        return new Scaffold(
          backgroundColor: theme.scaffoldColor,
          appBar: appBar(
            context,
            title: "Jobs",
          ),
          body: buildBody(vm),
          floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.library_add),
            onPressed: () => TMNavigate(context, JobsCreatePage(contacts: vm.contacts)),
          ),
        );
      },
    );
  }

  Widget buildBody(JobsViewModel vm) {
    if (vm.isLoading) {
      return loadingSpinner();
    }

    return SafeArea(
      top: false,
      child: CustomScrollView(
        slivers: <Widget>[
          JobList(jobs: vm.jobs),
        ],
      ),
    );
  }
}
