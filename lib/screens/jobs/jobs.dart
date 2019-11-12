import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/providers/dispatch_provider.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/jobs/actions.dart';
import 'package:tailor_made/rebloc/jobs/sort_type.dart';
import 'package:tailor_made/rebloc/jobs/view_model.dart';
import 'package:tailor_made/screens/jobs/_partials/jobs_filter_button.dart';
import 'package:tailor_made/screens/jobs/_partials/jobs_list.dart';
import 'package:tailor_made/screens/jobs/jobs_create.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_close_button.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_spinner.dart';
import 'package:tailor_made/widgets/theme_provider.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, JobsViewModel>(
      converter: (store) => JobsViewModel(store),
      builder: (
        BuildContext context,
        DispatchFunction dispatch,
        JobsViewModel vm,
      ) {
        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(vm: vm),
            body: Builder(builder: (context) {
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
            }),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.library_add),
              onPressed: () {
                Navigator.of(context).push<void>(MkNavigate.slideIn(
                  JobsCreatePage(contacts: vm.contacts),
                ));
              },
            ),
          ),
          onWillPop: () async {
            // TODO
            // if (_isSearching) {
            //   _handleSearchEnd(vm)();
            //   return false;
            // }
            return true;
          },
        );
      },
    );
  }
}

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar({
    Key key,
    @required this.vm,
  }) : super(key: key);

  final JobsViewModel vm;

  @override
  _AppBarState createState() => _AppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> with DispatchProvider<AppState> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider theme = ThemeProvider.of(context);

    return !_isSearching
        ? MkAppBar(
            title: Text("Jobs"),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: theme.appBarTitle.color,
                ),
                onPressed: onTapSearch,
              ),
              JobsFilterButton(
                vm: widget.vm,
                onTapSort: (SortType type) {
                  dispatchAction(SortJobs(payload: type));
                },
              ),
            ],
          )
        : AppBar(
            centerTitle: false,
            elevation: 1.0,
            leading: MkCloseButton(
              color: Colors.white,
              onPop: _handleSearchEnd(widget.vm),
            ),
            title: TextField(
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: ThemeProvider.of(context).subhead1Bold.copyWith(color: Colors.white),
              ),
              style: ThemeProvider.of(context).subhead1Bold.copyWith(color: Colors.white),
              onChanged: (term) => dispatchAction(SearchJobAction(payload: term)),
            ),
            bottom: PreferredSize(
              child: SizedBox(
                height: 1.0,
                child: widget.vm.isLoading
                    ? const LinearProgressIndicator(
                        backgroundColor: Colors.white,
                      )
                    : null,
              ),
              preferredSize: const Size.fromHeight(1.0),
            ),
          );
  }

  void onTapSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  VoidCallback _handleSearchEnd(JobsViewModel vm) {
    return () {
      dispatchAction(const CancelSearchJobAction());
      setState(() {
        _isSearching = false;
      });
    };
  }
}
