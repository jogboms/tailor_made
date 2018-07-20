import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/pages/jobs/ui/jobs_filter_button.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobsPage extends StatefulWidget {
  @override
  JobsPageState createState() => new JobsPageState();
}

class JobsPageState extends State<JobsPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    return new StoreConnector<ReduxState, JobsViewModel>(
      converter: (store) => JobsViewModel(store),
      onInit: (store) => store.dispatch(new InitDataEvents()),
      onDispose: (store) => store.dispatch(new DisposeDataEvents()),
      builder: (BuildContext context, JobsViewModel vm) {
        return WillPopScope(
          child: new Scaffold(
            backgroundColor: theme.scaffoldColor,
            appBar: _isSearching
                ? buildSearchBar(theme, vm)
                : buildAppBar(theme, vm),
            body: buildBody(vm),
            floatingActionButton: new FloatingActionButton(
              child: new Icon(Icons.library_add),
              onPressed: () =>
                  TMNavigate(context, JobsCreatePage(contacts: vm.contacts)),
            ),
          ),
          onWillPop: () async {
            if (_isSearching) {
              _handleSearchEnd(vm)();
              return false;
            }
            return true;
          },
        );
      },
    );
  }

  void onTapSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  Function() _handleSearchEnd(JobsViewModel vm) {
    return () {
      vm.cancelSearch();
      setState(() {
        _isSearching = false;
      });
    };
  }

  Widget buildSearchBar(TMTheme theme, JobsViewModel vm) {
    return new AppBar(
      centerTitle: false,
      elevation: 1.0,
      leading: new IconButton(
        icon: Icon(Icons.arrow_back, color: theme.appBarColor),
        onPressed: _handleSearchEnd(vm),
        tooltip: 'Back',
      ),
      title: new Theme(
        data: ThemeData(
          hintColor: Colors.white,
          primaryColor: kPrimaryColor,
        ),
        child: TextField(
          autofocus: true,
          decoration: new InputDecoration(
            hintText: 'Search...',
            hintStyle: ralewayBold(16.0),
          ),
          style: ralewayBold(16.0, theme.appBarColor),
          onChanged: (term) => vm.search(term),
        ),
      ),
      bottom: PreferredSize(
        child: SizedBox(
          height: 1.0,
          child: vm.isLoading
              ? LinearProgressIndicator(backgroundColor: Colors.white)
              : null,
        ),
        preferredSize: Size.fromHeight(1.0),
      ),
    );
  }

  Widget buildBody(JobsViewModel vm) {
    if (vm.isLoading && !vm.isSearching) {
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

  AppBar buildAppBar(TMTheme theme, JobsViewModel vm) {
    return appBar(
      context,
      title: "Jobs",
      actions: <Widget>[
        new IconButton(
          icon: new Icon(
            Icons.search,
            color: theme.appBarColor,
          ),
          onPressed: onTapSearch,
        ),
        JobsFilterButton(vm: vm),
      ],
    );
  }
}
