import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/presentation.dart';

import 'widgets/jobs_filter_button.dart';
import 'widgets/jobs_list.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelSubscriber<AppState, JobsViewModel>(
      converter: JobsViewModel.new,
      builder: (BuildContext context, DispatchFunction dispatcher, JobsViewModel vm) {
        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(vm: vm),
            body: Builder(
              builder: (BuildContext context) {
                if (vm.isLoading && !vm.isSearching) {
                  return const LoadingSpinner();
                }

                return SafeArea(
                  top: false,
                  child: CustomScrollView(
                    slivers: <Widget>[JobList(jobs: vm.jobs)],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.library_add),
              onPressed: () => context.registry.get<JobsCoordinator>().toCreateJob(vm.userId, vm.contacts),
            ),
          ),
          onWillPop: () async {
            if (vm.isSearching) {
              dispatcher(const JobsAction.searchCancel());
              return false;
            }
            return true;
          },
        );
      },
    );
  }
}

class _AppBar extends StatefulWidget implements PreferredSizeWidget {
  const _AppBar({required this.vm});

  final JobsViewModel vm;

  @override
  State<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends State<_AppBar> with StoreDispatchMixin<AppState> {
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    if (!_isSearching) {
      return CustomAppBar(
        title: const Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onTapSearch,
          ),
          JobsFilterButton(
            vm: widget.vm,
            onTapSort: (JobsSortType type) => dispatchAction(JobsAction.sort(type)),
          ),
        ],
      );
    }

    return AppBar(
      centerTitle: false,
      elevation: 1.0,
      leading: AppCloseButton(onPop: _handleSearchEnd),
      title: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Search...'),
        onChanged: (String term) => dispatchAction(JobsAction.search(term)),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: SizedBox(
          height: 1.0,
          child: widget.vm.isLoading ? const LinearProgressIndicator() : null,
        ),
      ),
    );
  }

  void _onTapSearch() => setState(() => _isSearching = true);

  void _handleSearchEnd() {
    dispatchAction(const JobsAction.searchCancel());
    setState(() => _isSearching = false);
  }
}
