import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/routing.dart';

import 'providers/filtered_jobs_state_provider.dart';
import 'widgets/jobs_filter_button.dart';
import 'widgets/jobs_list.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        final AsyncValue<FilteredJobsState> filteredJobs = ref.watch(filteredJobsProvider);

        return WillPopScope(
          child: Scaffold(
            appBar: _AppBar(loading: filteredJobs.isLoading),
            body: Builder(
              builder: (BuildContext context) {
                return filteredJobs.when(
                  skipLoadingOnReload: true,
                  data: (FilteredJobsState state) {
                    if (state.jobs.isEmpty) {
                      return const Center(
                        child: EmptyResultView(message: 'No jobs available'),
                      );
                    }

                    return SafeArea(
                      top: false,
                      child: CustomScrollView(
                        slivers: <Widget>[
                          JobList(jobs: state.jobs),
                        ],
                      ),
                    );
                  },
                  error: ErrorView.new,
                  loading: () => child!,
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.library_add),
              onPressed: () => context.router.toCreateJob(null),
            ),
          ),
          onWillPop: () async {
            final SearchJobQueryState queryState = ref.read(searchJobQueryStateProvider.notifier);
            if (queryState.isSearching) {
              queryState.setState('');
              return false;
            }
            return true;
          },
        );
      },
      child: const Center(child: LoadingSpinner()),
    );
  }
}

class _AppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const _AppBar({required this.loading});

  final bool loading;

  @override
  ConsumerState<_AppBar> createState() => _AppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarState extends ConsumerState<_AppBar> {
  late final SearchJobQueryState _queryProvider = ref.read(searchJobQueryStateProvider.notifier);
  late final SearchJobSortState _sortProvider = ref.read(searchJobSortStateProvider.notifier);
  late final TextEditingController _controller = TextEditingController(text: _queryProvider.currentState);
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(searchJobQueryStateProvider, (_, String next) {
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length, affinity: TextAffinity.upstream),
        );
      }
    });

    if (!_isSearching) {
      return CustomAppBar(
        title: const Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _onTapSearch,
          ),
          JobsFilterButton(
            sortType: ref.watch(searchJobSortStateProvider),
            onTapSort: _sortProvider.setState,
          ),
        ],
      );
    }

    return AppBar(
      leading: AppCloseButton(onPop: _handleSearchEnd),
      title: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Search...'),
        onChanged: _queryProvider.setState,
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: SizedBox(
          height: 1.0,
          child: widget.loading ? const LinearProgressIndicator() : null,
        ),
      ),
    );
  }

  void _onTapSearch() => setState(() => _isSearching = true);

  void _handleSearchEnd() {
    _queryProvider.setState('');
    setState(() => _isSearching = false);
  }
}
