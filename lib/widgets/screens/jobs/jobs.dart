import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/redux/view_models/jobs.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/screens/jobs/jobs_create.dart';
import 'package:tailor_made/widgets/screens/jobs/jobs_list.dart';
import 'package:tailor_made/widgets/screens/jobs/ui/jobs_filter_button.dart';

class JobsPage extends StatefulWidget {
  @override
  JobsPageState createState() => JobsPageState();
}

class JobsPageState extends State<JobsPage> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);

    return StoreConnector<AppState, JobsViewModel>(
      converter: (store) => JobsViewModel(store),
      builder: (BuildContext context, JobsViewModel vm) {
        return WillPopScope(
          child: Scaffold(
            appBar: _isSearching
                ? buildSearchBar(theme, vm)
                : buildAppBar(theme, vm),
            body: buildBody(vm),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.library_add),
              onPressed: () =>
                  MkNavigate(context, JobsCreatePage(contacts: vm.contacts)),
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

  Widget buildSearchBar(MkTheme theme, JobsViewModel vm) {
    return AppBar(
      centerTitle: false,
      elevation: 1.0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: theme.appBarTitle.color),
        onPressed: _handleSearchEnd(vm),
        tooltip: 'Back',
      ),
      title: Theme(
        data: ThemeData(
          hintColor: Colors.white,
          primaryColor: kPrimaryColor,
        ),
        child: TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search...',
            hintStyle: mkFontBold(16.0),
          ),
          style: mkFontBold(16.0, theme.appBarTitle.color),
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
      return const MkLoadingSpinner();
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

  Widget buildAppBar(MkTheme theme, JobsViewModel vm) {
    return MkAppBar(
      title: Text("Jobs"),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.search,
            color: theme.appBarTitle.color,
          ),
          onPressed: onTapSearch,
        ),
        JobsFilterButton(vm: vm),
      ],
    );
  }
}
